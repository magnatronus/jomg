// auto generated file
// generated - 2022-08-10 14:05:07.776487 
import 'version_model.dart';
import 'groups_model.dart';

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

	static ApiModel fromJson(Map<String,dynamic> json){
		return ApiModel(
			title: json['title'],
			heading: json['heading'],
			version: VersionModel.fromJson(json['version']),
			groups: (json['groups'] !=  null) ? json['groups'].map<GroupsModel>((json) => GroupsModel.fromJson(json)).toList() : json['groups'],
		);
	}
}
