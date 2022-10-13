import 'package:flutter/material.dart';
import 'package:oem_huahuan_1013/widget/measure_widget/measure_list.dart';
class MeasureMainScreen extends StatefulWidget {
  const MeasureMainScreen({Key? key}) : super(key: key);

  @override
  State<MeasureMainScreen> createState() => _MeasureMainScreenState();
}

class _MeasureMainScreenState extends State<MeasureMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MeasureList()
      ),
    );
  }
}
