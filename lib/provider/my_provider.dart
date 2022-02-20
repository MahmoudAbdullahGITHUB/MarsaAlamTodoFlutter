import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mars_alam_todo/shared/components/components.dart';
import 'package:sqflite/sqflite.dart';

class MyProvider extends ChangeNotifier {
  late Database _database;
  List<Map> newTasks = [];
  Map model = {
    'id': 'id',
    'title': 'title',
    'date': 'date',
    'time': 'time',
    'status': 'status',
  };
  bool updateFlag = false;

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (Database _database, int version) {
        _database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print(error.toString());
        });
      },
      onOpen: (Database _database) {
        getDataFromDatabase(_database);
        print('opened');
      },
    ).then((value) {
      _database = value;
      notifyListeners();
      // emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    return await _database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks (title,date,time,status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('task inserted' + value.toString());
        notifyListeners();
        // emit(AppInsertDatabaseState());
        getDataFromDatabase(_database);
      }).catchError((err) {
        print(err.toString());
      });
    });
  }

  void getDataFromDatabase(Database _database) {
    newTasks = [];
    // doneTasks = [];
    // archivedTasks = [];

    _database.rawQuery('SELECT * FROM tasks').then((value) {
      for (var element in value) {
        if (element['status'] == 'new') {
          print('element = $element');
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          // doneTasks.add(element);
        } else {
          // archivedTasks.add(element);
        }
      }
      notifyListeners();
    });
  }

  bool isBottomSheetShawn = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShawn = isShow;
    fabIcon = icon;
    notifyListeners();
  }

  void deleteRecordFromDatabase(int recordId) async {
    _database.rawDelete('DELETE FROM tasks WHERE id = ?', ['$recordId']).then(
        (value) {
      print('deleted record $value');
    });
    newTasks.removeWhere((element) => element['id'] == recordId);
    notifyListeners();
  }

  bool change = false;

  void openBottomSheet2() {
    print('yes2');
    scaffoldKey.currentState!
        .showBottomSheet(
          (context) => Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  defaultFormField(
                    prefix: Icons.title,
                    validate: (String? val) {
                      if (val!.isEmpty) {
                        return 'title is empty';
                      }
                      return null;
                    },
                    controller: titleController,
                    label: 'Task Title',
                    type: TextInputType.text,
                  ),
                  const SizedBox(height: 15),
                  defaultFormField(
                    prefix: Icons.watch_later_outlined,
                    validate: (String? val) {
                      if (val!.isEmpty) {
                        return 'time is empty';
                      }
                      return null;
                    },
                    controller: timeController,
                    label: 'Task Time',
                    type: TextInputType.datetime,
                    onTap: () {
                      showTimePicker(
                              context: context, initialTime: TimeOfDay.now())
                          .then((value) {
                        timeController.text = value!.format(context).toString();
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  defaultFormField(
                    prefix: Icons.calendar_today,
                    validate: (String? val) {
                      if (val!.isEmpty) {
                        return 'Date is empty';
                      }
                      return null;
                    },
                    controller: dateController,
                    label: 'Task Date',
                    type: TextInputType.datetime,
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.parse('2025-12-12'))
                          .then((value) {
                        dateController.text = DateFormat.yMMMd().format(value!);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          elevation: 20,
        )
        .closed
        .then((value) {
      print('yes3');
      changeBottomSheetState(isShow: false, icon: Icons.edit);
    });
    changeBottomSheetState(isShow: true, icon: Icons.add);
  }

  void openBottomSheet() {
    change = true;
    // isBottomSheetShawn=true;
    notifyListeners();
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  void onPress2(
    var context,
  ) {
    print('onPress2');
    if (isBottomSheetShawn) {
      print('work it');
      if (formKey.currentState!.validate()) {
        if (!updateFlag) {
          print('insert not update');
          insertToDatabase(
              date: dateController.text,
              time: timeController.text,
              title: titleController.text);
          Navigator.pop(context);
        } else {
          print('update not insert');
          _database.rawUpdate(
              'UPDATE tasks SET title = ?, time = ?, date = ? WHERE id = ?', [
            titleController.text,
            timeController.text,
            dateController.text,
            '${model['id']}'
          ]).then((value) => print('update vo = $value'));
          updateFlag = false;
          Navigator.pop(context);
          Map newModel = {};
          newModel['title'] = titleController.text;
          newModel['title'] = timeController.text;
          newModel['title'] = dateController.text;
          getDataFromDatabase(_database);
          print(
              'indexes ${newTasks.indexWhere((element) => element['id'] == model['id'])} pp ${model['id']}');
          // newTasks[newTasks.indexWhere(
          //     (element) => element['id'] == model['id'])] = newModel;
          // notifyListeners();
        }
      }
    } else {
      openBottomSheet2();
    }
  }

  void updateSheet(var context, Map model) {
    updateFlag = true;
    // _database.rawUpdate(
    //     'UPDATE tasks SET title = ?, time = ?, date = ? WHERE id = ?',
    //     [
    //       titleController.text,
    //       timeController.text,
    //       dateController.text,
    //       '${model['id']}'
    //     ]).then((value) =>print('update vo = $value'));
    this.model = model;
    titleController.text = model['title'];
    timeController.text = model['time'];
    dateController.text = model['date'];
    // onPress2(context);
    openBottomSheet2();
  }
}
