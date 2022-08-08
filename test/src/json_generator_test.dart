import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jomg/jomg.dart';

// Out test JSON
const testJsonStringOne = '''
{
  "id": 1,
  "name": "Test Entry",
  "comments_added": [
    {"date": "2202-01-01", "comment": "Happy New Year"}
  ],
  "visible": false
}
''';

main() {
  group("constructor", () {
    test('errors if name is empty', () {
      expect(
          () =>
              JsonObjectModelGenerator("", outputDirectory: "test/src/models"),
          throwsA(isA<AssertionError>()));
    });

    test('works correctly', () {
      expect(
          () => JsonObjectModelGenerator("entry",
              outputDirectory: "test/src/models"),
          returnsNormally);
    });
  });

  group("convert function", () {
    late JsonObjectModelGenerator generator;
    late Directory outputDirectory;

    setUp(() {
      outputDirectory = Directory("${Directory.current.path}/jomg_models");
      outputDirectory.createSync();
      generator = JsonObjectModelGenerator("entry",
          outputDirectory: outputDirectory.path);
    });

    test('errors if jsonString is empty', () {
      expect(() => generator.convert(""), throwsA(isA<AssertionError>()));
    });

    test('errors if jsonString is not valid json', () async {
      await expectLater(
          generator.convert("abc"), throwsA(isA<JOMGJsonFormatException>()));
    });

    test('convert runs correctly', () async {
      expect(() async => await generator.convert(testJsonStringOne),
          returnsNormally);
    });

    test('convert creates the 2 expected dart classes', () async {
      final jomg = JsonObjectModelGenerator("entry",
          outputDirectory: outputDirectory.path);
      await jomg.convert(testJsonStringOne);

      final dartFiles = outputDirectory.listSync(followLinks: false);
      expect(dartFiles.length, equals(2));
      final classOne = dartFiles[0];
      final classTwo = dartFiles[1];
      expect(classOne.path,
          equals("${outputDirectory.path}/comments_added_model.dart"));
      expect(classTwo.path, equals("${outputDirectory.path}/entry_model.dart"));

      // finally delete the temp files
      await outputDirectory.delete(recursive: true);
    });
  });
}
