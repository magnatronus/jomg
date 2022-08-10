// auto generated file
// generated - 2022-08-10 13:40:03.878917 
import 'comments_model.dart';

class EntryModel {

	final int? id;
	final String? name;
	final List<CommentsModel>? comments;
	final bool? visible;

	EntryModel({
		  this.id,
		  this.name,
		  this.comments,
		  this.visible,
	});

	static EntryModel fromJson(Map<String,dynamic> json){
		return EntryModel(
			id: json['id'],
			name: json['name'],
			comments: (json['comments'] !=  null) ? json['comments'].map<CommentsModel>((json) => CommentsModel.fromJson(json)).toList() : [],
			visible: json['visible'],
		);
	}
}
