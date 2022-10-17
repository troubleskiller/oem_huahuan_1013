class ProjectModel {
  //项目的序号
  int id;

  //项目的名字
  String name;

  //项目的描述
  String describe;

  //项目创建的时间
  String dateTime;

  ProjectModel({
    required this.dateTime,
    required this.name,
    required this.describe,
    required this.id,
  });



  factory ProjectModel.fromJson(Map<String, dynamic> parsedJson) {
    return ProjectModel(
      id: parsedJson['id'],
      name: parsedJson['name'],
      describe: parsedJson['describe'],
      dateTime: parsedJson['datetime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'describe': describe,
      'datetime': dateTime,
    };
  }
}