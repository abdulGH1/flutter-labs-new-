import 'package:floor/floor.dart';
import 'dart:async';
import 'item.dart';
import 'dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(version: 1, entities: [ToDoItem])
abstract class AppDatabase extends FloorDatabase {
  ToDoDao get toDoDao;
}
