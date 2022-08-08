import 'package:flutter_test/flutter_test.dart';

import 'package:jomg/jomg.dart';

main() {
  group("constructor", () {
    test('works correctly with no cast attribute', () {
      expect(() => JsonAttribute("String"), returnsNormally);
    });

    test('works correctly with cast attribute', () {
      expect(() => JsonAttribute("String", cast: "TestModel"), returnsNormally);
    });
  });
}
