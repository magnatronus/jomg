// auto generated file
// generated - 2022-08-10 13:40:03.842893 
import 'details_model.dart';

class GroupsModel {

	final String? groupName;
	final int? order;
	final List<DetailsModel>? details;

	GroupsModel({
		  this.groupName,
		  this.order,
		  this.details,
	});

	static GroupsModel fromJson(Map<String,dynamic> json){
		return GroupsModel(
			groupName: json['group_name'],
			order: json['order'],
			details: (json['details'] !=  null) ? json['details'].map<DetailsModel>((json) => DetailsModel.fromJson(json)).toList() : [],
		);
	}
}
