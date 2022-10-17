import 'package:flutter/material.dart';
import 'package:oem_huahuan_1013/database/hole_database.dart';
import 'package:oem_huahuan_1013/model/hole_model.dart';
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
            contentWidget: Container()
          );
        });
    // final result = await Navigator.push(context, _createRoute(_eventData));
    // if (result != null) {
    //   await _database.insertEvent(result);
    _holes = await _holeDatabaseService.selectRow(widget.group);
    setState(() {});
  }

  @override
  void dispose() {
    // _nameController.dispose();
    // _describeController.dispose();
    // _sideController.dispose();
    // _topController.dispose();
    // _depthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '测量',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
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
    );
  }
}
