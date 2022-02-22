import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  int currentIndex = 0;
  late Database database;
  bool isDone = true;
  bool isArchive = true;
  late List<Map> newTasks = [];
  late List<Map> doneTasks = [];
  late List<Map> archiveTasks = [];
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeNavBarState());
  }

  void changeTaskStatus({
    required bool isDone,
    required bool isArchive,
  }) {
    isDone = isDone;
    isArchive = isArchive;
    emit(AppChangeTaskStatusState());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        print('database created');
        await database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error in creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    return database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks (title, time, date, status) VALUES("$title","$time","$date","New")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error in creating table ${error.toString()}');
      });
    });
  }

  void updateData({
    required String status,
    required int id,
  }) {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  void getDataFromDatabase(database) async {
    emit(AppChangeTaskStatusState());
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then(
      (value) {
        value.forEach((element) {
          if (element['status'] == 'New')
            newTasks.add(element);
          else if (element['status'] == 'done')
            doneTasks.add(element);
          else
            archiveTasks.add(element);
        });
        emit(AppGetDatabaseState());
      },
    );
  }

  void changeBottomSheet({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
