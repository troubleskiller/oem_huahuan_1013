import 'package:flutter/material.dart';
import 'package:oem_huahuan_1013/database/project_database.dart';
import 'package:oem_huahuan_1013/model/peoject_model.dart';
import 'package:oem_huahuan_1013/widget/common_widget/common_app_bar.dart';
import 'package:oem_huahuan_1013/widget/common_widget/dialog_widget.dart';
import 'package:oem_huahuan_1013/widget/project_widget/project_widget.dart';

class MeasureMainScreen extends StatefulWidget {
  const MeasureMainScreen({Key? key}) : super(key: key);

  @override
  State<MeasureMainScreen> createState() => _MeasureMainScreenState();
}

class _MeasureMainScreenState extends State<MeasureMainScreen> {
  List<ProjectModel> project = <ProjectModel>[];
  final ProjectDatabaseService _projectDatabaseService =
      ProjectDatabaseService();
  ScrollController scrollController = ScrollController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _describeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _queryEvents();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
    _nameController.dispose();
    _describeController.dispose();
  }

  List<Widget> _getProjectsList(List<ProjectModel> events) {
    List<Widget> projectWidgets = <Widget>[];
    projectWidgets.add(const SizedBox(height: 6));
    for (ProjectModel event in events) {
      projectWidgets.add(
        MeasureEventList(
          projectModel: event,
        ),
      );
    }
    return projectWidgets;
  }
  _queryEvents() async {
    await _projectDatabaseService.init();
    project = await _projectDatabaseService.queryEvents();
    setState(() {});
  }

  void _newEvent() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return RenameDialog(
            contentWidget: RenameDialogContent(
              title: "新建一个项目",
              okBtnTap: () async {
                DateTime date = DateTime.now();
                String timestamp =
                    "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

                await _projectDatabaseService.addRow(
                    _nameController.text, _describeController.text, timestamp);
                _nameController.clear();
                _describeController.clear();
                project = await _projectDatabaseService.queryEvents();
                Navigator.of(context).pop();
                setState(() {});
              },
              nameController: _nameController,
              describeController: _describeController,
              cancelBtnTap: () {
                _nameController.clear();
                _describeController.clear();
              },
            ),
          );
        });
    // project = await _projectDatabaseService.queryEvents();
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: CustomTopAppBar(title: '项目选择',),
      body: ListView(children: _getProjectsList(project),),
      floatingActionButton: FloatingActionButton(
        onPressed: _newEvent,
        tooltip: '新增条条',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
