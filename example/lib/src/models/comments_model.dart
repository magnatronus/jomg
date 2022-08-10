// auto generated file
// generated - 2022-08-10 13:40:03.878671 

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
