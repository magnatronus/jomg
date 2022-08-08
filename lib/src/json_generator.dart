// Copyright (c) 2022 SpiralArm Consulting ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'conversion_utils.dart';
import 'json_attribute.dart';

/// Exception thrown when supplied JSON is not correct
class JOMGJsonFormatException implements Exception {
  final String filename;
  const JOMGJsonFormatException(this.filename);
  @override
  String toString() => 'JSON conversion/format error for file: $filename';
}

/// JsonObjectModelGenerator takes care of generating the various object models from the json that is found.
/// [name] is the name of the json file without the extension
/// [outputDirectory] where the generated models will be put
class JsonObjectModelGenerator {
  List<String> imports = [];
  final String name;
  final String outputDirectory;
  final bool allAttributesRequired;
  JsonObjectModelGenerator(this.name,
      {required this.outputDirectory, this.allAttributesRequired = false})
      : assert(name.isNotEmpty);

  /// Start the conversion process
  /// [jsonString] - the json that needs converting as a string
  Future<void> convert(String jsonString) async {
    // make sure the jsonString is not empty
    assert(jsonString.isNotEmpty);

    // open the destination file
    final output = File('$outputDirectory/${name}_model.dart').openWrite();

    // create the attribute map
    final attributeMap = _generateAttributeMap(jsonString);

    // generate a simple header
    output.writeln("// auto generated file");
    output.writeln("// generated - ${DateTime.now().toString()} ");

    // Add in any required imports
    if (imports.isNotEmpty) {
      for (final import in imports) {
        output.writeln(import);
      }
    }

    // Start class definition
    output.writeln("");
    output.writeln("class ${ConversionUtils.createModelName(name)} {");
    output.writeln("");

    // create attributes
    attributeMap.forEach((key, value) {
      final canBeNull = (allAttributesRequired) ? "" : "?";
      output.writeln(
          "\tfinal ${value.type}${(value.cast != null) ? '<${value.cast}>' : ''}$canBeNull ${ConversionUtils.prepName(key)};");
    });
    output.writeln("");

    // create the constructor
    output.writeln("\t${ConversionUtils.createModelName(name)}({");
    attributeMap.forEach((key, value) {
      final canBeNull = (allAttributesRequired) ? "required" : "";
      output.writeln("\t\t $canBeNull this.${ConversionUtils.prepName(key)},");
    });
    output.writeln("\t});\n");

    // create the static converter for the json object
    output.writeln(
        "\tstatic ${ConversionUtils.createModelName(name)} fromJson(Map<String,dynamic> json){");
    output.writeln("\t\treturn ${ConversionUtils.createModelName(name)}(");
    attributeMap.forEach((key, value) {
      if (value.type == "List" && value.cast != null) {
        output.writeln(
            "\t\t\t${ConversionUtils.prepName(key)}: json['$key'].map<${value.cast}>((json) => ${value.cast}.fromJson(json)).toList(),");
      } else {
        if (_isSubType(value.type)) {
          output.writeln(
              "\t\t\t${ConversionUtils.prepName(key)}: ${value.type}.fromJson(json['$key']),");
        } else {
          output
              .writeln("\t\t\t${ConversionUtils.prepName(key)}: json['$key'],");
        }
      }
    });
    output.writeln("\t\t);");
    output.writeln("\t}");

    // tidy up and close file
    output.writeln("}");
    await output.flush();
    output.close();
  }

  /// Detect if we are processing a generated type
  /// [type] this is the detected JSON attribute type either a Dart type of suffixed with Model for a List or MAp
  bool _isSubType(String type) {
    return type.contains("Model");
  }

  /// Generate an attribute map from the json primatives
  /// [value] the JSOn string containing the object to map
  Map<String, JsonAttribute> _generateAttributeMap(String value) {
    Map<String, JsonAttribute> attributes = {};
    try {
      jsonDecode(value).forEach((key, value) {
        if (value.runtimeType.toString().startsWith("_InternalLinkedHashMap") ||
            value.runtimeType.toString().startsWith("List")) {
          // attempt to deal with a list
          if (value.runtimeType.toString().startsWith("List")) {
            if (value.length > 0) {
              attributes.putIfAbsent(
                  key,
                  () => JsonAttribute("List",
                      cast: "${ConversionUtils.createModelName(key)}"));
              _processObject(key, value[0]);
            } else {
              attributes.putIfAbsent(key, () => JsonAttribute("List"));
            }
          }

          // deal with a Map
          if (value.runtimeType
              .toString()
              .startsWith("_InternalLinkedHashMap")) {
            attributes.putIfAbsent(key,
                () => JsonAttribute("${ConversionUtils.createModelName(key)}"));
            _processObject(key, value);
          }
        } else {
          // work around as we cannot have a variable called "is" and when doing language on is "is" - Icelandic so we append  append l ?
          if (key == "is") {
            key = "isl";
          }
          attributes.putIfAbsent(
              key, () => JsonAttribute(value.runtimeType.toString()));
        }
      });
    } on FormatException {
      throw JOMGJsonFormatException("$name.json");
    }
    return attributes;
  }

  /// This is where we recurse and deal with List and Map types
  /// [key]  the name of the object
  /// [value] the string representation of the JSON object
  void _processObject(String key, dynamic value) {
    imports.add("import '${key}_model.dart';");
    final converter =
        JsonObjectModelGenerator(key, outputDirectory: outputDirectory);
    converter.convert(jsonEncode(value));
  }
}
