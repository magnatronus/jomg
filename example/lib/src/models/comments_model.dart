// auto generated file
// generated - 2022-08-08 13:22:12.242787 

class CommentsModel {

	final String? date;
	final String? comment;

	CommentsModel({
		  this.date,
		  this.comment,
	});

	static CommentsModel fromJson(Map<String,dynamic> json){
		return CommentsModel(
			date: json['date'],
			comment: json['comment'],
		);
	}
}
