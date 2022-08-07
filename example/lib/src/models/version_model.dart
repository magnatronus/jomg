/// auto generated file
/// generated - 2022-08-07 10:10:03.703049
class VersionModel {
  final int? major;
  final int? minor;
  final String? copyright;

  VersionModel({
    this.major,
    this.minor,
    this.copyright,
  });

  static VersionModel fromJson(Map<String, dynamic> json) {
    return VersionModel(
      major: json['major'],
      minor: json['minor'],
      copyright: json['copyright'],
    );
  }
}
