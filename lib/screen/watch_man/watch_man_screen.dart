import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:oem_huahuan_1013/database/hole_database.dart';
import 'package:oem_huahuan_1013/database/measure_database.dart';
import 'package:oem_huahuan_1013/database/project_database.dart';
import 'package:oem_huahuan_1013/model/hole_model.dart';
import 'package:oem_huahuan_1013/model/measure_detail_model.dart';
import 'package:oem_huahuan_1013/model/peoject_model.dart';
import 'package:oem_huahuan_1013/screen/watch_man/measure_excel.dart';
import 'package:oem_huahuan_1013/widget/common_widget/common_app_bar.dart';

class SearchMainScreen extends StatefulWidget {
  const SearchMainScreen({Key? key}) : super(key: key);

  @override
  State<SearchMainScreen> createState() => _SearchMainScreenState();
}

class _SearchMainScreenState extends State<SearchMainScreen> {
  var selectEventItemValue = 0;
  var selectHoleItemValue = 0;

  var selectMeasureItemValue = '请选择测量时间';

  List<ProjectModel> projects = [];
  List<HoleModel> holes = [];
  List<String> dateTimes = [];

  List<MeasureModel> measures = [];
  List<DropdownMenuItem<int>> eventItems = [
    const DropdownMenuItem<int>(
      child: Text(
        '请选择项目',
        style: TextStyle(color: Colors.blue),
      ),
      value: 0,
    ),
  ];
  List<DropdownMenuItem<int>> holeItems = [
    const DropdownMenuItem<int>(
      child: Text(
        '请选择孔',
        style: TextStyle(color: Colors.blue),
      ),
      value: 0,
    ),
  ];
  List<DropdownMenuItem<String>> measureItems = [
    const DropdownMenuItem<String>(
      child: Text(
        '请选择测量时间',
        style: TextStyle(color: Colors.blue),
      ),
      value: '请选择测量时间',
    ),
  ];
  final ProjectDatabaseService _projectDatabaseService =
  ProjectDatabaseService();
  final HoleDatabaseService _holeDatabaseService = HoleDatabaseService();
  final MeasureDatabaseService _measureDatabaseService =
  MeasureDatabaseService();

  MeasureModel? measureModel;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _queryEvents();
  }

  _queryEvents() async {
    projects = await _projectDatabaseService.queryEvents();
    generateEventItemList();
    setState(() {});
  }

  List<DropdownMenuItem<int>> generateEventItemList() {
    for (ProjectModel project in projects) {
      eventItems.add(DropdownMenuItem<int>(
        child: Text(
          project.name,
          style: TextStyle(color: Colors.blue),
        ),
        value: project.id,
      ));
    }
    return eventItems;
  }

  Future generateHoleItemList(selectEventItemValue) async {
    holes = await _holeDatabaseService.selectRow(selectEventItemValue);
    List<DropdownMenuItem<int>> curHoleItems = [
      const DropdownMenuItem<int>(
        child: Text(
          '请选择孔',
          style: TextStyle(color: Colors.blue),
        ),
        value: 0,
      ),
    ];
    for (HoleModel hole in holes) {
      curHoleItems.add(DropdownMenuItem<int>(
        child: Text(
          hole.name,
          style: TextStyle(color: Colors.blue),
        ),
        value: hole.id,
      ));
    }
    holeItems = curHoleItems;
  }

  Future generateMeasureItemList(selectMeasureItemValue) async {
    List<String> dateTime = [];

    ///todo check if wrong;
    measures = await _measureDatabaseService.selectRow(selectMeasureItemValue);
    if (measures == []) {
      List<DropdownMenuItem<String>> curMeasureItems = [
        const DropdownMenuItem<String>(
          child: Text(
            '请选择测量时间',
            style: TextStyle(color: Colors.blue),
          ),
          value: '请选择测量时间',
        ),
      ];
      measureItems = curMeasureItems;
    }
    for (MeasureModel measureModel in measures) {
      if (!dateTime.contains(measureModel.dateTime)) {
        dateTime.add(measureModel.dateTime);
      }
    }
    List<DropdownMenuItem<String>> curMeasureItems = [
      const DropdownMenuItem<String>(
        child: Text(
          '请选择测量时间',
          style: TextStyle(color: Colors.blue),
        ),
        value: '请选择测量时间',
      ),
    ];
    for (String a in dateTime) {
      curMeasureItems.add(DropdownMenuItem<String>(
        child: Text(
          a,
          style: TextStyle(color: Colors.blue),
        ),
        value: a,
      ));
    }
    measureItems = curMeasureItems;
    dateTimes = dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopAppBar(
        title: '查询',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            SizedBox(height: 20,),
            DropdownButton(
              items: eventItems,
              onChanged: (value) {
                if (selectHoleItemValue != 0) {
                  BrnDialogManager.showConfirmDialog(context,
                      title: '监测到目前正处于其他孔项目选择中',
                      cancel: '取消',
                      confirm: '初始化项目查询', onConfirm: () async {
                        selectMeasureItemValue = '请选择测量时间';
                        selectHoleItemValue = 0;
                        selectEventItemValue = 0;
                        Navigator.pop(context);
                        generateHoleItemList(selectEventItemValue);
                        generateMeasureItemList(selectHoleItemValue);
                        setState(() {});
                      });
                } else {
                  if (value is int) {
                    setState(() {
                      selectEventItemValue = value;
                      generateHoleItemList(selectEventItemValue);
                    });
                    // print(value);
                  }
                }
              },
              value: selectEventItemValue,
              isExpanded: true,
            ),
            DropdownButton(
              items: holeItems,
              onChanged: (value) {
                if (selectHoleItemValue != 0) {
                  BrnDialogManager.showConfirmDialog(context,
                      title: '监测到目前正处于其他时间选择中',
                      cancel: '取消',
                      confirm: '初始化洞口查询', onConfirm: () async {
                        selectMeasureItemValue = '请选择测量时间';
                        selectHoleItemValue = 0;
                        Navigator.pop(context);
                        generateMeasureItemList(selectHoleItemValue);
                        setState(() {});
                      });
                } else {
                  if (value is int) {
                    setState(() {
                      selectHoleItemValue = value;
                      generateMeasureItemList(selectHoleItemValue);
                    });
                    // print(value);
                  }
                }
              },
              value: selectHoleItemValue,
              isExpanded: true,
            ),
            DropdownButton(
              items: measureItems,
              onChanged: (value) {
                if (value is String) {
                  setState(() {
                    selectMeasureItemValue = value;
                    // generateHoleItemList(selectEventItemValue);
                  });
                  // print(value);
                }
              },
              value: selectMeasureItemValue,
              isExpanded: true,
            ),
            SizedBox(height: 30,),
            GestureDetector(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                height: 50,
                width: 350,
                child: const Center(
                  child: Text(
                    '孔型变化查看',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              onTap: () {
                BrnDialogManager.showConfirmDialog(context,
                    title: "当前版本仅支持查看与第一次的孔型变化查看",
                    cancel: '取消',
                    confirm: '确定',
                    onConfirm: () async {
                      BrnToast.show("确定", context);
                      Navigator.pop(context);
                      List<MeasureModel> curList = await _measureDatabaseService
                          .selectDate(selectMeasureItemValue);
                      List<MeasureModel> preList = [];
                      if (dateTimes.indexWhere(
                              (element) => element == selectMeasureItemValue) +
                          1 <=
                          dateTimes.length - 1) {
                        preList =
                        await _measureDatabaseService.selectDate(dateTimes.last);
                      } else {
                        for (int i = 0; i < curList.length; i++) {
                          preList.add(MeasureModel(
                              noM: 0,
                              x: 0,
                              y: 0,
                              dateTime: '0',
                              depth: curList[i].depth,
                          ));
                        }
                      }
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ChartBreakLine(
                      //           curList: curList,
                      //           preList: preList,
                      //         )));
                    },
                    onCancel: () {
                      BrnToast.show("取消", context);
                      Navigator.pop(context);
                    });
              },
            ),
            //work as margin
            SizedBox(height: 30,),
            GestureDetector(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                height: 50,
                width: 350,
                child: const Center(
                  child: Text(
                    '孔形查看',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              onTap: () async {
                List<MeasureModel> measureList = await _measureDatabaseService
                    .selectDate(selectMeasureItemValue);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MeasureExcel(measureList: measureList)));
              },
            ),
          ],),

          Container(
            margin: EdgeInsets.only(bottom: 30),
            alignment: Alignment.center,
            child: Text('©️华桓电子科技有限公司',
              style: TextStyle(
                  color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
