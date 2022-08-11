// auto generated file
// generated - 2022-08-11 10:20:34.832203 

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
