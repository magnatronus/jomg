// auto generated file
// generated - 2022-08-10 14:05:07.763773 

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
