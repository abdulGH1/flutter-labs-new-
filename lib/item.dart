import 'package:floor/floor.dart';

@entity
class ToDoItem {

  @primaryKey
  final int? id; // Made nullable for auto-increment
  final String name; // Renamed from `item` to `name`
  final int quantity;

  static int ID = 1;

  ToDoItem(this.id, this.name, this.quantity);

}
