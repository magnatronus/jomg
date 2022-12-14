// Copyright (c) 2022 SpiralArm Consulting ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

import 'json_generator.dart';

/// Exception thrown when no jomg entry found in pubspec.yaml
class JOMGYamlException implements Exception {}

/// Exception thrown whenno JSON file in src_dir
class JOMGNoSourceFilesException implements Exception {}

/// Exception thrown when no jomg src_dir found
class JOMGNoSrcDirException implements Exception {}

/// Exception thrown when no jomg output_dir found
class JOMGNoOutputDirException implements Exception {}

/// The main build function
/// This starts the process of converting the found JSON files into Dart class definitions
Future<void> build({Map? config}) async {
  late final Directory sourceDirectory;
  late final Directory outputDirectory;
  late final bool allAttributesRequired;

  // load yaml settings for directory settings
  File yamlFile = File("pubspec.yaml");
  final yamlString = yamlFile.readAsStringSync();
  Map yaml = (config != null) ? config : loadYaml(yamlString);

  // check that the required settings are defined
  final jomg = yaml['jomg'];
  try {
    // check any defined dirs exist
    sourceDirectory = Directory(jomg['src_dir']);
    outputDirectory = Directory(jomg['output_dir']);
  } catch (_) {
    throw JOMGYamlException();
  }

  // check if we should turn on allAttributesRequired
  allAttributesRequired = jomg['all_attributes_required'] ?? false;

  // check existence of specified directories
  if (!sourceDirectory.existsSync()) {
    throw JOMGNoSrcDirException();
  }
  if (!outputDirectory.existsSync()) {
    throw JOMGNoOutputDirException();
  }

  // Look for JSON files and if found process and convert
  final jsonFiles = sourceDirectory.listSync(followLinks: false);
  if (jsonFiles.isNotEmpty) {
    for (final jsonFile in jsonFiles) {
      final name = p.basenameWithoutExtension(jsonFile.path);
      if (p.extension(jsonFile.path) == ".json") {
        final jsonObjectConverter = JsonObjectModelGenerator(name,
            outputDirectory: jomg['output_dir'],
            allAttributesRequired: allAttributesRequired);
        final jsonString =
            File('${jomg['src_dir']}/$name.json').readAsStringSync();
        await jsonObjectConverter.convert(jsonString);
      }
    }
  } else {
    throw JOMGNoSourceFilesException();
  }
}
