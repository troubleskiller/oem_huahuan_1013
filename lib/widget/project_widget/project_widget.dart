import 'package:flutter/material.dart';
import 'package:oem_huahuan_1013/model/peoject_model.dart';
import 'package:oem_huahuan_1013/screen/measure/hole_screen.dart';

class MeasureEventList extends StatelessWidget {
  const MeasureEventList({Key? key, required this.projectModel, required this.deleteProject})
      : super(key: key);
  final ProjectModel projectModel;
  final Function deleteProject;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HoleScreen(group: projectModel.id)));
      },
      onHorizontalDragStart: (DragStartDetails dragStartDetails){

      },
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (DismissDirection direction){
          if(direction==DismissDirection.startToEnd){
            deleteProject();
          }
        },
        direction: DismissDirection.startToEnd,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              CommonLineForEvent(
                  lineName: '序号:', lineEvent: projectModel.id.toString()),
              CommonLineForEvent(lineName: '项目名:', lineEvent: projectModel.name),
              CommonLineForEvent(
                  lineName: '简介:', lineEvent: projectModel.describe),
              CommonLineForEvent(
                  lineName: '创建时间:', lineEvent: projectModel.dateTime.toString()),
            ],
          ),
        ),
      ),
    );
  }
}

class CommonLineForEvent extends StatelessWidget {
  const CommonLineForEvent(
      {Key? key, required this.lineName, required this.lineEvent})
      : super(key: key);
  final String? lineName;
  final String? lineEvent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          lineName ?? '',
          style: TextStyle(
              color: Colors.white,
              // fontWeight: FontWeight.bold,
              letterSpacing: 2),
        ),
        Text(lineEvent ?? '',
          style: TextStyle(
              color: Colors.white,
              // fontWeight: FontWeight.bold,
              letterSpacing: 2),),
      ],
    );
  }
}
