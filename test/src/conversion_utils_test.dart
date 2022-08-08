import 'package:flutter_test/flutter_test.dart';
import 'package:jomg/jomg.dart';

main() {
  group("ConversionUtils", () {
    test("prepName should be transform string to camelCase", () {
      const source = "this is a test";
      final result = ConversionUtils.upperCaseFirst(source);
      expect(result, equals("This is a test"));
      expect(result, isNot(equals(source)));
    });

    test(
        "prepName should be transform string to camelCase and uppercase the first char as well",
        () {
      const source = "additional_comment_string";
      final result = ConversionUtils.prepName(source, firstUpper: true);
      expect(result, equals("AdditionalCommentString"));
    });

    test("values with _ should be transformed to camelCase", () {
      const source = "this_test_string";
      final result = ConversionUtils.prepName(source);
      expect(result, equals("thisTestString"));
    });

    test("CreateModelName is generated correctly", () {
      expect(
          ConversionUtils.createModelName("comment"), equals("CommentModel"));
      expect(ConversionUtils.createModelName("additional_comment"),
          equals("AdditionalCommentModel"));
    });
  });
}
