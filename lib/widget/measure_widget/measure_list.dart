import 'package:flutter/material.dart';
import 'package:oem_huahuan_1013/model/measure_detail_model.dart';
import 'package:provider/provider.dart';

import 'measure_widget.dart';
class MeasureList extends StatelessWidget {
  const MeasureList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MeasureDetailModel detailModel = context.watch<MeasureDetailModel>();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:  [
        MeasureCommonWidget(title: 'X轴', detail: detailModel.x.toString(),),
        MeasureCommonWidget(title: 'Y轴', detail: detailModel.y.toString(),),
        MeasureCommonWidget(title: '温度', detail: detailModel.tmp.toString(),),
        MeasureCommonWidget(title: '电量', detail: detailModel.bat.toString(),),
      ],),
    );
  }
}
