import 'version_model.dart';
import 'groups_model.dart';

/// auto generated file
/// generated - 2022-08-07 10:10:03.713392
class ApiModel {
  final String? title;
  final String? heading;
  final VersionModel? version;
  final List<GroupsModel>? groups;

  ApiModel({
    this.title,
    this.heading,
    this.version,
    this.groups,
  });

  static ApiModel fromJson(Map<String, dynamic> json) {
    return ApiModel(
      title: json['title'],
      heading: json['heading'],
      version: VersionModel.fromJson(json['version']),
      groups: json['groups']
          .map<GroupsModel>((json) => GroupsModel.fromJson(json))
          .toList(),
    );
  }
}
