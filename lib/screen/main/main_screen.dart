import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:oem_huahuan_1013/screen/measure/measure_main_screen.dart';
import 'package:oem_huahuan_1013/screen/test/test_connect_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('主页'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 10,
          ),
          BrnNormalButton(
            text: '测量',
            fontSize: 40,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => MeasureMainScreen(),
                ),
              );
            },
          ),
          BrnNormalButton(
            text: '查询',
            fontSize: 40,
          ),
          BrnNormalButton(
            text: '测试',
            fontSize: 40,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => TestConnectScreen(),
                ),
              );
            },
          ),
          SizedBox(
            height: 40,
          ),
        ],
      )),
    );
  }
}
