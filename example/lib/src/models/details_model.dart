// auto generated file
// generated - 2022-08-11 10:20:34.840682 

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
