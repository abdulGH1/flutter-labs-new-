import 'package:flutter/material.dart';
import 'item.dart';
import 'app_database.dart';

late AppDatabase database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = await $FloorAppDatabase.databaseBuilder('todo.db').build();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ListPage());
  }
}

class ListPage extends StatefulWidget {
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final _itemController = TextEditingController();
  final _quantityController = TextEditingController();
  List<ToDoItem> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final dao = database.toDoDao;
    final list = await dao.findAllItems();
    setState(() {
      _items = list;
    });
  }

  void _addItem() async {
    final name = _itemController.text.trim();
    final qty = int.tryParse(_quantityController.text.trim()) ?? 1;

    if (name.isEmpty) return;

    final newItem = ToDoItem(ToDoItem.ID++, name, qty);
    await database.toDoDao.insertItem(newItem);

    setState(() {
      _items.add(newItem);
      _itemController.clear();
      _quantityController.clear();
    });
  }

  void _confirmDelete(ToDoItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete Item"),
        content: Text("Do you want to delete '${item.item}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () async {
              await database.toDoDao.deleteItem(item);
              setState(() {
                _items.remove(item);
              });
              Navigator.pop(ctx);
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("To-Do List")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _itemController,
                  decoration: InputDecoration(hintText: "Item"),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "Qty"),
                ),
              ),
              ElevatedButton(onPressed: _addItem, child: Text("Add"))
            ]),
            SizedBox(height: 16),
            Expanded(
              child: _items.isEmpty
                  ? Center(child: Text("No items"))
                  : ListView.builder(
                itemCount: _items.length,
                itemBuilder: (ctx, i) {
                  final item = _items[i];
                  return ListTile(
                    title: Text(item.item),
                    subtitle: Text("Qty: ${item.quantity}"),
                    onLongPress: () => _confirmDelete(item),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
