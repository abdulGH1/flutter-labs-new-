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
  ToDoItem? _selectedItem;

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
    final name = _itemController.text;
    final quantity = int.tryParse(_quantityController.text) ?? 1;
    if (name.isNotEmpty) {
      final dao = database.toDoDao;
      await dao.insertItem(ToDoItem(null, name, quantity));
      _itemController.clear();
      _quantityController.clear();
      _loadItems();
    }
  }

  void _deleteItem(ToDoItem item) async {
    final dao = database.toDoDao;
    await dao.deleteItem(item);
    setState(() {
      _selectedItem = null;
    });
    _loadItems();
  }

  void _closeDetail() {
    setState(() {
      _selectedItem = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    Widget itemListView = Expanded(
      child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            title: Text(item.name),
            onTap: () {
              setState(() {
                _selectedItem = item;
              });
            },
          );
        },
      ),
    );

    Widget? detailView;
    if (_selectedItem != null) {
      detailView = Expanded(
        child: Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${_selectedItem!.name}", style: TextStyle(fontSize: 20)),
                SizedBox(height: 8),
                Text("Quantity: ${_selectedItem!.quantity}"),
                SizedBox(height: 8),
                Text("ID: ${_selectedItem!.id}"),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => _deleteItem(_selectedItem!),
                      child: Text("Delete"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red), // FIXED
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _closeDetail,
                      child: Text("Close"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Week 9 Master-Detail")),
      body: isWideScreen
          ? Row(
        children: [
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(child: TextField(controller: _itemController, decoration: InputDecoration(labelText: "Item name"))),
                      SizedBox(width: 8),
                      Expanded(child: TextField(controller: _quantityController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Quantity"))),
                      SizedBox(width: 8),
                      ElevatedButton(onPressed: _addItem, child: Text("Add")),
                    ],
                  ),
                ),
                itemListView,
              ],
            ),
          ),
          if (detailView != null) detailView,
        ],
      )
          : _selectedItem == null
          ? Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _itemController, decoration: InputDecoration(labelText: "Item name"))),
                SizedBox(width: 8),
                Expanded(child: TextField(controller: _quantityController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Quantity"))),
                SizedBox(width: 8),
                ElevatedButton(onPressed: _addItem, child: Text("Add")),
              ],
            ),
          ),
          itemListView,
        ],
      )
          : Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${_selectedItem!.name}", style: TextStyle(fontSize: 20)),
                SizedBox(height: 8),
                Text("Quantity: ${_selectedItem!.quantity}"),
                SizedBox(height: 8),
                Text("ID: ${_selectedItem!.id}"),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => _deleteItem(_selectedItem!),
                      child: Text("Delete"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red), // FIXED
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _closeDetail,
                      child: Text("Close"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
