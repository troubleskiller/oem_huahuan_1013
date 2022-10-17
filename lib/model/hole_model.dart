class HoleModel {
  //孔的分组
  int noM;

  //孔的序号
  int id;

  //孔的名字
  String name;

  //孔的深度
  double holeWidth;

  //顶部的预留高度
  double restForTop;

  //测量的间隔
  double sideBet;

  //创建的时间
  String dateTime;

  HoleModel({
    required this.dateTime,
    required this.name,
    required this.id,
    required this.noM,
    required this.holeWidth,
    required this.restForTop,
    required this.sideBet,
  });

  factory HoleModel.fromJson(Map<String, dynamic> parsedJson) {
    return HoleModel(
      id: parsedJson['id'],
      name: parsedJson['name'],
      holeWidth: parsedJson['holeWidth'],
      dateTime: parsedJson['datetime'],
      restForTop: parsedJson['restForTop'],
      sideBet: parsedJson['sideBet'],
      noM: parsedJson['noM'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'holeWidth': holeWidth,
      'datetime': dateTime,
      'restForTop': restForTop,
      'sideBet': sideBet,
      'noM': noM,
    };
  }
}