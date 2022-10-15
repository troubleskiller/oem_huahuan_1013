import 'package:flutter/material.dart';
import 'package:oem_huahuan_1013/screen/login/login_screen.dart';
import 'package:oem_huahuan_1013/screen/main/main_screen.dart';
import 'package:provider/provider.dart';

import 'model/measure_detail_model.dart';

void main() {
  runApp(
      MultiProvider(providers: [ChangeNotifierProvider(
        create: (context) => MeasureDetailModel(),
      ),],child: const MyApp(),)
      );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
