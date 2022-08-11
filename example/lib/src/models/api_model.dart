// auto generated file
// generated - 2022-08-11 10:20:34.842558 
import 'version_model.dart';
import 'groups_model.dart';

class ApiModel {

	final String? title;
	final String? heading;
	final VersionModel? version;
	final List? tags;
	final List<GroupsModel>? groups;

	ApiModel({
		  this.title,
		  this.heading,
		  this.version,
		  this.tags,
		  this.groups,
	});

	static ApiModel fromJson(Map<String,dynamic> json){
		return ApiModel(
			title: json['title'],
			heading: json['heading'],
			version: VersionModel.fromJson(json['version']),
			tags: json['tags'],
			groups: (json['groups'] !=  null) ? json['groups'].map<GroupsModel>((json) => GroupsModel.fromJson(json)).toList() : json['groups'],
		);
	}
}
