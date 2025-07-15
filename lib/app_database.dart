import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'item.dart';
import 'dao.dart';

part 'app_database.g.dart'; // This is the generated file

@Database(version: 1, entities: [ToDoItem])
abstract class AppDatabase extends FloorDatabase {
  ToDoDao get toDoDao;
}
