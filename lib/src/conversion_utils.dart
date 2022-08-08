// Copyright (c) 2022 SpiralArm Consulting ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

/// A set of utilities for help in converting the JSON
class ConversionUtils {
  /// Helper function to convert the first char of a string to uppercase
  /// [value] the string to uppercase
  static String upperCaseFirst(String value) {
    return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
  }

  /// This will generate a model name for the supplied attribute [name]
  /// the convention is
  /// 1. convert the name using camelCase of required (and uppercase first char)
  /// 2. append "Model"  to the end
  static createModelName(String name) {
    final camelCase = ConversionUtils.prepName(name, firstUpper: true);
    return "${camelCase}Model";
  }

  /// create a JSON/Dart compatible version of the attribute found
  /// this will use camelCase and split if it finds an _ in the json attribute [name]
  /// i.e.  age converts to age
  /// but age_now converts to ageNow
  /// this is to provide consistency when generating the object models
  /// [name] the original attribute name to convert
  static String prepName(String name, {firstUpper = false}) {
    int pos = name.indexOf("_");
    if (pos == -1) {
      return (firstUpper) ? ConversionUtils.upperCaseFirst(name) : name;
    }
    List<String> components = name.split("_");
    late String result;
    components.asMap().forEach((key, value) {
      if (key == 0) {
        result = (firstUpper) ? ConversionUtils.upperCaseFirst(value) : value;
      } else {
        result += ConversionUtils.upperCaseFirst(value);
      }
    });
    return result;
  }
}
