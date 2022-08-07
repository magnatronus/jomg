import 'details_model.dart';

/// auto generated file
/// generated - 2022-08-07 10:10:03.713156
class GroupsModel {
  final String? groupName;
  final int? order;
  final List<DetailsModel>? details;

  GroupsModel({
    this.groupName,
    this.order,
    this.details,
  });

  static GroupsModel fromJson(Map<String, dynamic> json) {
    return GroupsModel(
      groupName: json['group_name'],
      order: json['order'],
      details: json['details']
          .map<DetailsModel>((json) => DetailsModel.fromJson(json))
          .toList(),
    );
  }
}
