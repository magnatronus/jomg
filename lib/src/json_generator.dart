// Copyright (c) 2022 SpiralArm Consulting ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'json_attribute.dart';

/// JsonObjectModelGenerator takes care of generating the various object models from the json that is found.
/// [name] is the name of the json file without the extension
/// [outputDirectory] where the generated models will be put
///
class JsonObjectModelGenerator {
  List<String> imports = [];
  final String name;
  final String outputDirectory;
  final bool allAttributesRequired;
  JsonObjectModelGenerator(this.name,
      {required this.outputDirectory, this.allAttributesRequired = false});

  /// Start the conversion process
  /// [jsonString] - the json that needs converting as a string
  Future<void> convert(String jsonString) async {
    // open the destination file
    final output = File('$outputDirectory/${name}_model.dart').openWrite();

    // create the attribute map
    final attributeMap = _generateAttributeMap(jsonString);

    // generate a simple header
    output.writeln("/// auto generated file");
    output.writeln("/// generated - ${DateTime.now().toString()} ");
    output.writeln("class ${_upperCaseFirst(name)}Model {");
    output.writeln("");

    // create attributes
    attributeMap.forEach((key, value) {
      final canBeNull = (allAttributesRequired) ? "" : "?";
      output.writeln(
          "\tfinal ${value.type}${(value.cast != null) ? '<${value.cast}>' : ''}$canBeNull ${_prepName(key)};");
    });
    output.writeln("");

    // create the constructor
    output.writeln("\t${_upperCaseFirst(name)}Model({");
    attributeMap.forEach((key, value) {
      final canBeNull = (allAttributesRequired) ? "required" : "";
      output.writeln("\t\t $canBeNull this.${_prepName(key)},");
    });
    output.writeln("\t});\n");

    // create the static converter for the json object
    output.writeln(
        "\tstatic ${_upperCaseFirst(name)}Model fromJson(Map<String,dynamic> json){");
    output.writeln("\t\treturn ${_upperCaseFirst(name)}Model(");
    attributeMap.forEach((key, value) {
      if (value.type == "List" && value.cast != null) {
        output.writeln(
            "\t\t\t${_prepName(key)}: json['$key'].map<${value.cast}>((json) => ${value.cast}.fromJson(json)).toList(),");
      } else {
        if (_isSubType(value.type)) {
          output.writeln(
              "\t\t\t${_prepName(key)}: ${value.type}.fromJson(json['$key']),");
        } else {
          output.writeln("\t\t\t${_prepName(key)}: json['$key'],");
        }
      }
    });
    output.writeln("\t\t);");
    output.writeln("\t}");

    // tidy up and close file
    output.writeln("}");
    await output.flush();
    output.close();

    // now append any imports
    if (imports.isNotEmpty) {
      final currentContent =
          File('$outputDirectory/${name}_model.dart').readAsLinesSync();
      currentContent.insertAll(0, imports);
      final append = File('$outputDirectory/${name}_model.dart').openWrite();
      append.writeAll(currentContent, "\n");
      await append.flush();
      append.close();
    }
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
    jsonDecode(value).forEach((key, value) {
      if (value.runtimeType.toString().startsWith("_InternalLinkedHashMap") ||
          value.runtimeType.toString().startsWith("List")) {
        // attempt to deal with a list
        if (value.runtimeType.toString().startsWith("List")) {
          if (value.length > 0) {
            attributes.putIfAbsent(
                key,
                () => JsonAttribute("List",
                    cast: "${_upperCaseFirst(key)}Model"));
            processObject(key, value[0]);
          } else {
            attributes.putIfAbsent(key, () => JsonAttribute("List"));
          }
        }

        // deal with a Map
        if (value.runtimeType.toString().startsWith("_InternalLinkedHashMap")) {
          attributes.putIfAbsent(
              key, () => JsonAttribute("${_upperCaseFirst(key)}Model"));
          processObject(key, value);
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
    return attributes;
  }

  /// This is where we recurse and deal with List and Map types
  /// [key]  the name of the object
  /// [value] the string representation of the JSON object
  processObject(String key, dynamic value) {
    imports.add("import '${key}_model.dart';");
    final converter =
        JsonObjectModelGenerator(key, outputDirectory: outputDirectory);
    converter.convert(jsonEncode(value));
  }

  /// Helper function to convert the first char of a string to uppercase
  /// [value] the string to uppercase
  String _upperCaseFirst(String value) {
    return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
  }

  /// create a JSON/Dart compatible version of the attribute found
  /// this will use camelCase and split if it finds an _ in the json attribute [name]
  /// i.e.  age converts to age
  /// but age_now converts to ageNow
  /// this is to provide consistency when generating the object models
  String _prepName(String name) {
    int pos = name.indexOf("_");
    if (pos == -1) {
      return name;
    }
    List<String> components = name.split("_");
    late String result;
    components.asMap().forEach((key, value) {
      if (key == 0) {
        result = value;
      } else {
        result += _upperCaseFirst(value);
      }
    });
    return result;
  }
}
