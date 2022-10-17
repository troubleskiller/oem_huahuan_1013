import 'package:flutter/foundation.dart';
import 'package:oem_huahuan_1013/model/peoject_model.dart';
import 'package:sqflite/sqflite.dart';


const String databaseName = "project.db";
bool isInit = false;
class ProjectDatabaseService {
  init() async {
      if(!isInit){
        createTable();
      }
  }

  Future<Database> _getDatabase() async {
    String databasesPath = await getDatabasesPath() + databaseName;
    Database database = await openDatabase(databasesPath);
    return database;
  }

  ///删除数据库
  Future<void> _deleteDatabase() async {
    String databasesPath = await getDatabasesPath() + databaseName;
    await deleteDatabase(databasesPath);
  }

  ///创建user_info的表
  Future<void> createTable() async {
    Database database = await _getDatabase();
    database.execute(
        'CREATE TABLE project_info (id INTEGER PRIMARY KEY, name TEXT, describe TEXT, dateTime TEXT)');
  }

  ///删除user_info表
  Future<void> deleteTable() async {
    Database database = await _getDatabase();
    database.execute('DROP TABLE project_info');
  }

  ///查询表中全部数据
  Future<void> _selectAllRow() async {
    Database database = await _getDatabase();
    List<Map> list = await database.rawQuery('SELECT * FROM project_info');
    //上面这条语句等价于下面这条语句
    //List<Map> list =await database.query("user_info");
    if (kDebugMode) {
      print("查询表中全部数据");
      print(list);
    }
  }


  ///向表中增加一条数据，其中id（主键）自生成，name为徐晖
  Future<void> addRow(String name, String describe, String datetime) async {
    Database database = await _getDatabase();
    int id = await database.rawInsert(
        'INSERT INTO project_info(name,describe,dateTime) VALUES("$name","$describe","$datetime")');
    //上面这条语句等价于下面这条语句
    //int id=await database.insert("user_info", {'name': '徐晖'});
    if (kDebugMode) {
      print('新插入的数据的ID是：$id');
    }
  }

  ///删除表中所有name字段为徐晖的记录
  Future<void> _deleteRow() async {
    Database database = await _getDatabase();
    int count = await database
        .rawDelete('DELETE FROM project_info WHERE name = ?', ['徐晖']);
    //上面这条语句等价于下面这条语句
    //int count=await database.delete("user_info",where: 'name = ?', whereArgs: ['徐晖']);

    if (kDebugMode) {
      print('删除表中所有name字段为徐晖的记录，共删除$count条记录');
    }
  }


  Future<List<ProjectModel>> queryEvents() async {
    Database database = await _getDatabase();
    List<Map<String, dynamic>> maps = await database.query('project_info');
    return List.generate(maps.length, (i) {
      return ProjectModel(
          name: maps[i]['name'],
          dateTime: maps[i]['dateTime'],
          id: maps[i]['id'],
          describe: maps[i]['describe']);
    }).reversed.toList();
  }
}
