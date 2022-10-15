import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:oem_huahuan_1013/helper/common_helper.dart';
import 'package:oem_huahuan_1013/model/measure_detail_model.dart';
import 'package:oem_huahuan_1013/screen/main/main_screen.dart';
import 'package:oem_huahuan_1013/widget/measure_widget/measure_list.dart';
import 'package:provider/provider.dart';

class Test extends StatefulWidget {
  const Test({
    Key? key,
    required this.device,
  }) : super(key: key);

  final BluetoothDevice device;

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late DateTime dateTime;

  ///sin 后乘的
  double mult = 0;
  List<BluetoothService> services = [];
  BluetoothCharacteristic? readCharacteristic;
  BluetoothCharacteristic? characteristic;
  BluetoothCharacteristic? writeCharacteristic;

  //正测
  List<double> measureList = [];
  List<List<double>> measureMainList = [];
  List<MeasureModel> trueList = [];
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findServices();

    ///should do
    widget.device.state.listen((state) {
      if (state == BluetoothDeviceState.disconnected) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => MainScreen(),
            ),);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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

          },
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MeasureList(),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      writeDataToDevice();
                    },
                    child: Container(
                        height: 50,
                        width: 200,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: const BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        child: Center(
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
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    '请注意：测试页面的x轴、y轴并非最终测试结果。',
                    style: TextStyle(
                        color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              )
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
              double x = double.parse(b[1]);
              double y = double.parse(differString[1]);
              // double x = double.parse(
              //     (sin(double.parse(b[1])) * mult).toStringAsFixed(3));
              // double y = double.parse(
              //     (sin(double.parse(differString[1])) * mult).toStringAsFixed(3));
              double tmp = double.parse(differString[2]);
              double bat = CommonHelper.toInt(double.parse(differString[3]));
              if(mounted){
                context.read<MeasureDetailModel>().updateDetail(x, y, tmp, bat);
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
