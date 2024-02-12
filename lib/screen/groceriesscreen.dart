import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:udemy_section11/Models/grocery_item.dart';
import 'package:http/http.dart' as http;
import 'package:udemy_section11/data/categories.dart';
import 'package:udemy_section11/screen/newgrocerie.dart';

class groceriesScreen extends StatefulWidget {
  const groceriesScreen({super.key});

  State<groceriesScreen> createState() {
    return _groceriesScreenState();
  }
}

class _groceriesScreenState extends State<groceriesScreen> {
  List<GroceryItem> _listesGrocery = [];
  var _isLoaded = true;
  var newgrocerie;
  String? _error;
  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  void _loadItem() async {
    final url = Uri.https(
        'houssainedatabase-default-rtdb.europe-west1.firebasedatabase.app',
        'shopping-list.json');
    final response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode > 400) {
      setState(() {
        _error = "Cannot find the data please correct your url";
      });
    }

    final List<GroceryItem> _loadedItems = [];
    final Map<String, dynamic> listDate = jsonDecode(response.body);
    for (final item in listDate.entries) {
      final category = categories.entries
          .firstWhere(
              (element) => element.value.title == item.value['category'])
          .value;
      _loadedItems.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category));
    }
    setState(() {
      _listesGrocery = _loadedItems;
      _isLoaded = false;
    });
  }

  void _addGrocerie(context) async {
    final item = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const newGrocerie()));
    if (item == null) {
      return;
    }
    setState(() {
      _listesGrocery.add(item);
    });
  }

  void _removeItem(GroceryItem item) async {
    var index = _listesGrocery.indexOf(item);
    setState(() {
      _listesGrocery.remove(item);
    });
    final url = Uri.https(
        'houssainedatabase-default-rtdb.europe-west1.firebasedatabase.app',
        'shopping-list/${item.id}.json');
    final response = await http.delete(url);
    if (response.statusCode > 400) {
      setState(() {
        _listesGrocery.insert(index, item);
      });
    }
    setState(() {
      _listesGrocery.remove(item);
    });
  }

  @override
  Widget build(context) {
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    Widget actuelScreen = Center(child: CircularProgressIndicator());

    if (_isLoaded) {
      return actuelScreen;
    }
    Widget content = ListView.builder(
        itemCount: _listesGrocery.length,
        itemBuilder: (ctx, index) => Dismissible(
              key: ValueKey(_listesGrocery[index].name),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                _removeItem(_listesGrocery[index]);
              },
              child: ListTile(
                title: Text(_listesGrocery[index].name),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: _listesGrocery[index].category.color,
                ),
                trailing: Text(_listesGrocery[index].quantity.toString()),
              ),
            ));

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              title: const Text('Your Groceries',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 55, 58, 60),
              actions: [
                IconButton(
                  icon: const Icon(
                    color: Colors.white,
                    Icons.add,
                  ),
                  onPressed: () {
                    _addGrocerie(context);
                  },
                )
              ]),
          body: content),
    );
  }
}
