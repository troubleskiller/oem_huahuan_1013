import 'package:flutter/material.dart';
import 'package:oem_huahuan_1013/database/hole_database.dart';
import 'package:oem_huahuan_1013/model/hole_model.dart';
import 'package:oem_huahuan_1013/widget/common_widget/common_app_bar.dart';
import 'package:oem_huahuan_1013/widget/common_widget/dialog_widget.dart';
import 'package:oem_huahuan_1013/widget/measure_widget/hole_list.dart';

class HoleScreen extends StatefulWidget {
  const HoleScreen({Key? key, required this.group}) : super(key: key);
  final int group;

  @override
  State<HoleScreen> createState() => _HoleScreenState();
}

final TextEditingController _nameController = TextEditingController();

final TextEditingController _sideController = TextEditingController();

final TextEditingController _topController = TextEditingController();

final TextEditingController _describeController = TextEditingController();

final TextEditingController _depthController = TextEditingController();

class _HoleScreenState extends State<HoleScreen> {
  List<HoleModel> _holes = <HoleModel>[];
  final HoleDatabaseService _holeDatabaseService = HoleDatabaseService();
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController();

  @override
  @override
  void initState() {
    super.initState();
    _queryHoles();
  }

  _queryHoles() async {
    await _holeDatabaseService.init();
    _holes = await _holeDatabaseService.selectRow(widget.group);
    print(_holes.length);
    // _events = await _database.queryEvents();
    // print(_events[0].describe);
    setState(() {});
  }

  List<Widget> _getHolesList(List<HoleModel> holes) {
    List<Widget> holeWidgets = <Widget>[];
    holeWidgets.add(const SizedBox(height: 6));
    for (HoleModel hole in _holes) {
      holeWidgets.add(
        MeasureHoleList(
          holeModel: hole,
          deleteHole: () {
            _holeDatabaseService.deleteRow(hole.id);
          },
        ),
      );
    }
    return holeWidgets;
  }

  void _newEvent() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return RenameDialog(
              contentWidget: HoleDialogContent(
            title: '新建测量孔',
            cancelBtnTap: () {
              _nameController.clear();
              _depthController.clear();
              _topController.clear();
              _sideController.clear();
              _describeController.clear();
            },
            okBtnTap: () async {
              DateTime date = DateTime.now();
              String timestamp =
                  "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

              await _holeDatabaseService.addRow(
                  widget.group,
                  _nameController.text,
                  double.parse(_depthController.text),
                  double.parse(_topController.text),
                  double.parse(_sideController.text),
                  timestamp);
              _nameController.clear();
              _depthController.clear();
              _topController.clear();
              _sideController.clear();
              _describeController.clear();
              _holes = await _holeDatabaseService.selectRow(widget.group);
              Navigator.of(context).pop();

              setState(() {});
            },
            describeController: _describeController,
            nameController: _nameController,
            sideController: _sideController,
            topController: _topController,
            depthController: _depthController,
          ));
        });
    // final result = await Navigator.push(context, _createRoute(_eventData));
    // if (result != null) {
    //   await _database.insertEvent(result);
    _holes = await _holeDatabaseService.selectRow(widget.group);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomTopAppBar(
        title: '孔选择',
      ),
      body: Container(
          color: Colors.black12,
          alignment: Alignment.center,
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: ListView(
            key: UniqueKey(),
            children: _getHolesList(_holes),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: _newEvent,
        tooltip: '新增条条',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
