import 'package:floor/floor.dart';

@entity
class ToDoItem {
  @primaryKey
  final int id;
  final String item;
  final int quantity;

  static int ID = 1;

  ToDoItem(this.id, this.item, this.quantity) {
    if (id >= ID) {
      ID = id + 1;
    }
  }
}
