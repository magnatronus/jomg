import 'dart:convert';

import 'models/api_model.dart';

// this is just a copy of the example json for testing
// this data would normally come from an API call
const jsonAsString = '''
{
  "title": "API Result Data",
  "heading": "This is an example JSON file for testing JOMG",
  "version": {
    "major": 1,
    "minor": 0,
    "copyright": "Steve Rogers"
  },
  "tags": [
    "test",
    "json",
    "convert"
  ],  
  "groups": [
      {
          "group_name": "Bus Stats",
          "order": 1,
          "details": [
              {
                  "is_visible": false,
                  "heading": "Late running buses.",
                  "order": 1,
                  "percentage": 13.255
              },
              {
                  "is_visible": true,
                  "heading": "Cancelled buses.",
                  "order": 2,
                  "percentage": 4.5
              }
          ]
      },
      {
        "group_name": "Train Stats",
        "order": 2,
        "details": [
            {
                "is_visible": false,
                "heading": "Late running trains.",
                "order": 1,
                "percentage": 9.45
            },
            {
                "is_visible": true,
                "heading": "Cancelled trains.",
                "order": 2,
                "percentage": 35.62
            }
        ]
    }      
  ]
}
''';

/// This is a faux API, usually the JSON woud come from an HTTPs call of some sort but here we hard code
/// and assume we have obtained the JSON data without error
class FauxApi {
  /// issue the API call to get the data
  Future<ApiModel> callApi() async {
    final json = jsonDecode(jsonAsString);
    return ApiModel.fromJson(json);
  }
}
