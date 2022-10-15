import 'package:flutter/material.dart';

///孔内不同时间测量的数据
class MeasureModel {
  //different hole
  int noM;

  //x -偏移
  double x;

  //y -偏移
  double y;

  //fan x -偏移
  double fx;

  //fan y -偏移
  double fy;

  //y -偏移
  double tmp;

  String dateTime;

  double depth;

  int isDouble;

  MeasureModel({
    required this.noM,
    required this.x,
    required this.y,
    required this.fx,
    required this.fy,
    required this.tmp,
    required this.dateTime,
    required this.depth,
    required this.isDouble,
  });

  factory MeasureModel.fromJson(Map<String, dynamic> parsedJson) {
    return MeasureModel(
      noM: parsedJson['noM'],
      isDouble: parsedJson['isDouble'],
      x: parsedJson['x'],
      y: parsedJson['y'],
      tmp: parsedJson['tmp'],
      dateTime: parsedJson['dateTime'],
      fy: parsedJson['fy'],
      fx: parsedJson['fx'],
      depth: parsedJson['depth'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'fx': fx,
      'fy': fy,
      'datetime': dateTime,
      'tmp': tmp,
      'noM': noM,
      'depth': depth,
      'isDouble': isDouble,
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
