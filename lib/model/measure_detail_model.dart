import 'package:flutter/material.dart';

///孔内不同时间测量的数据
class MeasureModel {
  //different hole
  int noM;

  //x -偏移
  double x;

  //y -偏移
  double y;



  String dateTime;

  double depth;


  MeasureModel({
    required this.noM,
    required this.x,
    required this.y,
    required this.dateTime,
    required this.depth,
  });

  factory MeasureModel.fromJson(Map<String, dynamic> parsedJson) {
    return MeasureModel(
      noM: parsedJson['noM'],
      x: parsedJson['x'],
      y: parsedJson['y'],
      dateTime: parsedJson['dateTime'],
      depth: parsedJson['depth'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'datetime': dateTime,
      'noM': noM,
      'depth': depth,
    };
  }
}

class MeasureDetailModel with ChangeNotifier {
  //x -偏移
  double? x;

  //y -偏移
  double? y;

  double? tmp;

  double? bat;

  MeasureDetailModel({
    this.x = 0,
    this.y = 0,
    this.tmp = 0,
    this.bat = 0,
  });

  void updateDetail(double nX, double nY, double nTmp, double nBat) {
    if (!(x == nX && y == nY && tmp == nTmp && bat == nBat)) {
      x = nX;
      y = nY;
      tmp = nTmp;
      bat = nBat;
      notifyListeners();
    }
  }
  void resetDetail() {
      x = 0;
      y = 0;
      tmp = 0;
      bat = 0;
      notifyListeners();
  }
}
