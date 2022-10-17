import 'package:flutter/material.dart';
import 'package:oem_huahuan_1013/model/hole_model.dart';
import 'package:oem_huahuan_1013/widget/common_widget/dialog_widget.dart';
import 'package:oem_huahuan_1013/widget/project_widget/project_widget.dart';


class MeasureHoleList extends StatelessWidget {
  const MeasureHoleList({
    Key? key,
    required this.holeModel,
    required this.deleteHole,
  }) : super(key: key);
  final HoleModel holeModel;
  final Function deleteHole;

  @override
  Widget build(BuildContext context) {
    bool _switchSelected = true;
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          builder: (BuildContext context) {
            //返回内部
            return Container(
              height: 150,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '取消',
                        style:
                        TextStyle(fontSize: 18, color: Colors.blueAccent),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('正反测量'),
                      StatefulBuilder(
                        builder: (BuildContext context,
                            void Function(void Function()) setState) {
                          return Switch(
                            value: _switchSelected, //当前状态
                            onChanged: (value) {
                              _switchSelected = value;
                              setState(() {});
                            },
                          );
                        },
                      )
                    ],
                  ),
                  Container(
                    height: 58,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return RenameDialog(
                                contentWidget: Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                    height: 200,
                                    // width: 10000,
                                    alignment: Alignment.bottomCenter,
                                    child: Column(
                                      children: [
                                        const Text(
                                          '将设备放入到孔底部，打开蓝牙，按确定继续。',
                                          style: TextStyle(fontSize: 19),
                                        ),
                                        Container(
                                          height: 50,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            GestureDetector(
                                              child: Container(
                                                width: 50,
                                                height: 30,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(5)),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    '取消',
                                                    style:
                                                    TextStyle(fontSize: 22),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            GestureDetector(
                                              child: Container(
                                                width: 50,
                                                height: 30,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(5)),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    '确定',
                                                    style:
                                                    TextStyle(fontSize: 22),
                                                  ),
                                                ),
                                              ),
                                              onTap: () async {
                                                // BluetoothDevice.fromId(id)
                                                //
                                                // await device.connect(
                                                //   // timeout: const Duration(seconds: 20), autoConnect: true
                                                // );
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             ConnectBluePage(
                                                //               holeModel:
                                                //               holeModel,
                                                //               isDouble:
                                                //               _switchSelected,
                                                //             )));
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                              );
                            });
                      },
                      child: const Center(
                        child: Text(
                          '去测量',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          context: context,
        );
      },
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (DismissDirection direction){
          if(direction==DismissDirection.startToEnd){
            deleteHole();
          }
        },
        direction: DismissDirection.startToEnd,
        child: Container(
          decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.all(Radius.circular(20))),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              CommonLineForEvent(lineName: '名称:', lineEvent: holeModel.name),
              CommonLineForEvent(
                  lineName: '孔深:', lineEvent: holeModel.holeWidth.toString()),
              CommonLineForEvent(
                  lineName: '孔部预留:', lineEvent: holeModel.restForTop.toString()),
              CommonLineForEvent(
                  lineName: '测量间隔:', lineEvent: holeModel.sideBet.toString()),
              CommonLineForEvent(
                  lineName: '创建时间:', lineEvent: holeModel.dateTime.toString()),
            ],
          ),
        ),
      ),
      // onLongPress: longPressFunction(),
    );
  }
}

