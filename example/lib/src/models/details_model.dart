// auto generated file
// generated - 2022-08-10 13:40:03.841514 

class DetailsModel {

	final bool? isVisible;
	final String? heading;
	final int? order;
	final double? percentage;

	DetailsModel({
		  this.isVisible,
		  this.heading,
		  this.order,
		  this.percentage,
	});

	static DetailsModel fromJson(Map<String,dynamic> json){
		return DetailsModel(
			isVisible: json['is_visible'],
			heading: json['heading'],
			order: json['order'],
			percentage: json['percentage'],
		);
	}
}
