import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:udemy_section11/Models/grocery_item.dart';
import 'package:udemy_section11/data/categories.dart';

class newGrocerie extends StatefulWidget {
  const newGrocerie({super.key});
  @override
  State<newGrocerie> createState() {
    return _newGrocerieState();
  }
}

class _newGrocerieState extends State<newGrocerie> {
  final _formKey = GlobalKey<FormState>();
  var _entredName = "";
  var _entredNumber = -1;
  var _isPushed = false;
  var _entredCategories;
  
  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'houssainedatabase-default-rtdb.europe-west1.firebasedatabase.app',
          'shopping-list.json');
      setState(() {
        _isPushed = true;
      });
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'name': _entredName,
            'quantity': _entredNumber,
            'category': _entredCategories.title,
          }));

      print(response.body);

      final newItem = jsonDecode(response.body);

      if (context.mounted) {
        Navigator.of(context).pop(GroceryItem(
            id: newItem['name'],
            name: _entredName,
            quantity: _entredNumber,
            category: _entredCategories));
      }
    }
  }

  @override
  Widget build(context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add a new Grocerie'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  onSaved: (value) {
                    _entredName = value!;
                  },
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('title'),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.length >= 51) {
                      return 'Title must be between 1 and 50 character';
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text('Quantity'),
                        ),
                        initialValue: '1',
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Quantity must be a valid positive number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _entredNumber = int.tryParse(value!)!;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                          items: [
                            for (final item in categories.entries)
                              DropdownMenuItem(
                                  value: item.value,
                                  child: Row(children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      color: item.value.color,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(item.value.title)
                                  ]))
                          ],
                          onChanged: (value) {
                            _entredCategories = value;
                          }),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: _isPushed
                            ? null
                            : () {
                                _formKey.currentState!.reset();
                              },
                        child: const Text('Reset')),
                    ElevatedButton(
                        onPressed: _isPushed ? null : _saveItem,
                        child: _isPushed == false
                            ? Text('Save')
                            : Icon(Icons.refresh))
                  ],
                )
              ]),
            )),
      ),
    );
  }
}
