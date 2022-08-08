// auto generated file
// generated - 2022-08-08 13:22:12.193746 

class VersionModel {

	final int? major;
	final int? minor;
	final String? copyright;

	VersionModel({
		  this.major,
		  this.minor,
		  this.copyright,
	});

	static VersionModel fromJson(Map<String,dynamic> json){
		return VersionModel(
			major: json['major'],
			minor: json['minor'],
			copyright: json['copyright'],
		);
	}
}
