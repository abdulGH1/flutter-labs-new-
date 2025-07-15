import 'package:floor/floor.dart';
import 'item.dart';

@dao
abstract class ToDoDao {
  @Query('SELECT * FROM ToDoItem')
  Future<List<ToDoItem>> findAllItems();

  @insert
  Future<void> insertItem(ToDoItem item);

  @delete
  Future<void> deleteItem(ToDoItem item);
}
