// Copyright (c) 2022 SpiralArm Consulting ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

// ignore_for_file: avoid_print

import 'package:jomg/jomg.dart';

void main(List<String> arguments) async {
  try {
    print("Running JOMG builder.");
    await build();
    print("JOMG builder completed.");
  } on JOMGJsonFormatException catch (e) {
    print(e.toString());
    return;
  } on JOMGYamlException {
    print(
        "No or incorrect jomg: entry definition in the pubspec.yaml. It MUST have both src_dir and output_dir defined.");
    return;
  } on JOMGNoSourceFilesException {
    print("No source json files found in defined jomg.src_dir");
    return;
  } on JOMGNoSrcDirException {
    print("Specified jomg.src_dir does not exist");
    return;
  } on JOMGNoOutputDirException {
    print("Specified jomg.output_dir does not exist");
    return;
  }
}
