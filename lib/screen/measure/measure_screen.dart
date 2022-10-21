import 'dart:math';

import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:oem_huahuan_1013/database/measure_database.dart';
import 'package:oem_huahuan_1013/helper/common_helper.dart';
import 'package:oem_huahuan_1013/model/hole_model.dart';
import 'package:oem_huahuan_1013/model/measure_detail_model.dart';
import 'package:oem_huahuan_1013/screen/main/main_screen.dart';
import 'package:oem_huahuan_1013/widget/measure_widget/measure_list.dart';
import 'package:provider/provider.dart';

class MeasureScreen extends StatefulWidget {
  const MeasureScreen({
    Key? key,
    required this.device,
    required this.holeModel,
    required this.isDouble,
  }) : super(key: key);

  final BluetoothDevice device;
  final HoleModel holeModel;
  final bool isDouble;

  @override
  State<MeasureScreen> createState() => _MeasureScreenState();
}

class _MeasureScreenState extends State<MeasureScreen> {
  late DateTime dateTime;

  int holeCount = 0;
  int testCount = 0;

  int antiCount = 0;
  int preCount = 0;
  bool hasTest = false;

  bool done = false;

  ///sin 后乘的
  late double mult;
  List<BluetoothService> services = [];
  BluetoothCharacteristic? readCharacteristic;
  BluetoothCharacteristic? characteristic;
  BluetoothCharacteristic? writeCharacteristic;

  //正
  List<List<double>> measureMainList = [];

  //反
  List<List<double>> measureSecondList = [];
  List<MeasureModel> trueList = [];

  final MeasureDatabaseService _measureDatabaseService =
      MeasureDatabaseService();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void saveMeasureData(List<MeasureModel> list) {
    DateTime date = DateTime.now();
    String timestamp =
        "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

    for (MeasureModel measureModel in list) {
      _measureDatabaseService.addRow(
        measureModel.noM,
        measureModel.x,
        measureModel.y,
        measureModel.depth,
        timestamp,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findServices();
    mult = widget.holeModel.sideBet * 1000;
    holeCount = CommonHelper.getHoleCount(widget.holeModel.holeWidth,
        widget.holeModel.restForTop, widget.holeModel.sideBet);
    preCount = holeCount;

    dateTime = DateTime.now();

    ///should do
    widget.device.state.listen((state) {
      if (state == BluetoothDeviceState.disconnected) {
        BrnDialogManager.showSingleButtonDialog(context,
            label: "确定",
            title: '提示',
            warning: '蓝牙已断开连接，请重新连接！', onTap: () {
              // BrnToast.show('知道了', context);
              Navigator.pop(context);
            });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MeasureDetailModel detailModel = context.watch<MeasureDetailModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '测量',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.blue,
          ),
          onPressed: () async {
            widget.device.disconnect();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => const MainScreen(),
              ),
            );
          },
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(children: [
          const MeasureList(),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  writeDataToDevice();
                },
                child: Container(
                    height: 50,
                    width: 200,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: const BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '开始测试',
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 15,
                          color: Colors.white,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
              ),
              const SizedBox(
                height: 50,
              ),
              BrnEnhanceNumberCard(
                itemChildren: [
                  BrnNumberInfoItemModel(
                    title: '待测量的孔的数量',
                    number: holeCount.toString(),
                  )
                ],
              ),
              BrnBottomButtonPanel(
                mainButtonName: '保存本次测量',
                mainButtonOnTap: () {
                  if (holeCount >= 1) {
                    if (holeCount == 1) {
                      hasTest = true;
                    }

                    widget.isDouble
                        ? done
                            ? () {
                                measureMainList[testCount][0] =
                                    (measureMainList[testCount][0] -
                                            detailModel.x!) /
                                        2;
                                measureMainList[testCount][1] =
                                    (measureMainList[testCount][1] -
                                            detailModel.y!) /
                                        2;
                              }
                            : measureMainList.add([
                                detailModel.x ?? 0,
                                detailModel.y ?? 0,
                                widget.holeModel.sideBet * testCount -
                                    widget.holeModel.holeWidth
                              ])
                        : measureMainList.add([
                            detailModel.x ?? 0,
                            detailModel.y ?? 0,
                            widget.holeModel.sideBet * testCount -
                                widget.holeModel.holeWidth
                          ]);
                    // if (!widget.isDouble ||
                    //     (widget.isDouble && !done)) {
                    if (holeCount != 1) {
                      testCount++;
                    }
                    // } else {
                    //   if(holeCount!=1){
                    //     testCount--;
                    //   }
                    // }
                    setState(() {
                      holeCount--;
                    });
                  } else {
                    BrnDialogManager.showSingleButtonDialog(context,
                        label: "确定", title: '提示', warning: '已经测完了', onTap: () {
                      // BrnToast.show('知道了', context);
                      Navigator.pop(context);
                    });
                  }
                },
                secondaryButtonName: '删除上次测量记录',
                secondaryButtonOnTap: () {
                  if (holeCount <= preCount - 1) {
                    if (holeCount == 0) {
                      hasTest = false;
                    }
                    // if (!widget.isDouble ||
                    //     (widget.isDouble && !done && !hasTest)) {
                    if (holeCount != preCount - 1) {
                      testCount--;
                    }
                    // } else {
                    //   if(holeCount!=preCount-1){
                    //     testCount++;
                    //   }
                    // }
                    measureMainList.removeLast();

                    setState(() {
                      holeCount++;
                    });
                  } else {
                    BrnDialogManager.showSingleButtonDialog(context,
                        label: "确定",
                        title: '提示',
                        warning: '没有可删的测量数据啦！', onTap: () {
                      // BrnToast.show('知道了', context);
                      Navigator.pop(context);
                    });
                  }
                },
              ),
              widget.isDouble
                  ? done
                      ? BrnBottomButtonPanel(
                          mainButtonName: '保存测量结果',
                          enableMainButton: hasTest,
                          mainButtonOnTap: () {
                            for (List<double> a in measureMainList) {
                              MeasureModel measureModel = MeasureModel(
                                noM: widget.holeModel.id,
                                x: a[0],
                                y: a[1],
                                dateTime: dateTime.toIso8601String(),
                                depth: a[2],
                              );
                              trueList.add(measureModel);

                              // print('${a[0]}-------------------');
                            }
                            saveMeasureData(trueList);
                            // _measureDatabaseService.deleteRow(widget.holeModel.noM);
                            _measureDatabaseService
                                .selectRow(widget.holeModel.noM);
                            // measureMainList = [];
                            widget.device.disconnect();
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => const MainScreen()));
                          },
                        )
                      : BrnBottomButtonPanel(
                          mainButtonName: '进行反测',
                          enableMainButton: hasTest,
                          mainButtonOnTap: () {
                            done = true;
                            hasTest = false;
                            holeCount = preCount;
                            testCount = 0;
                            setState(() {});
                          },
                        )
                  : BrnBottomButtonPanel(
                      mainButtonName: '保存测量结果',
                      enableMainButton: hasTest,
                      mainButtonOnTap: () {
                        for (List<double> a in measureMainList) {
                          MeasureModel measureModel = MeasureModel(
                            noM: widget.holeModel.id,
                            x: a[0],
                            y: a[1],
                            dateTime: dateTime.toIso8601String(),
                            depth: a[2],
                          );
                          trueList.add(measureModel);
                          print('${a[0]}-------------------');
                        }

                        saveMeasureData(trueList);
                        _measureDatabaseService.selectRow(widget.holeModel.noM);
                        widget.device.disconnect();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => const MainScreen()));
                      },
                    ),
              const Text(
                '注意：这里的x轴，y轴是经过计算的',
                style:
                    TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  ///should do
  Future findServices() async {
    services = await widget.device.discoverServices();
    for (var service in services) {
      // do something with service
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.properties.notify) {
          setCharacteristicNotify(c, true);
        }
        if (c.uuid == Guid('0000fff2-0000-1000-8000-00805f9b34fb')) {
          writeCharacteristic = c;
        }
      }
    }
  }

  ///should do
  void setCharacteristicNotify(BluetoothCharacteristic c, bool notify) async {
    bool result = await c.setNotifyValue(notify);
    if (result) {
      print('set BluetoothCharacteristic Notify success');
      c.value.listen(
        (value) {
          String res = "";
          for (var i = 0; i < value.length; i++) {
            res += String.fromCharCode(int.parse(value[i].toRadixString(10)));
          }
          if (res != '') {
            List<String> differString = res.split(',');
            if (differString.length == 4 &&
                differString[0].split('=').length == 2) {
              String a = differString[0];
              List<String> b = a.split('=');
              double x = double.parse(
                  (sin(double.parse(b[1])) * mult).toStringAsFixed(5));
              double y = double.parse(
                  (sin(double.parse(differString[1])) * mult)
                      .toStringAsFixed(5));
              double tmp = double.parse(differString[2]);
              double bat = CommonHelper.toInt(double.parse(differString[3]));
              if (mounted) {
                context.read<MeasureDetailModel>().updateDetail(x, y, tmp, bat);
                print(
                    '--------${double.parse(b[1])}XXXXXXXX-------${double.parse(differString[1])}XXXXXXXX');
                print('$x,-------$y,-----');
              }
            }
          }
        },
      );
    } else {
      print('set BluetoothCharacteristic Notify fail');
    }
  }

  Future writeDataToDevice() async {
    writeCharacteristic?.write(
        [0x5A, 0x46, 0x2B, 0x41, 0x55, 0x54, 0x4F, 0x3D, 0x31, 0x0D, 0x0A]);
  }
}
