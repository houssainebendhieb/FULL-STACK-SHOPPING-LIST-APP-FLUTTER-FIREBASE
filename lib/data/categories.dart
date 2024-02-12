import 'package:flutter/material.dart';

import 'package:udemy_section11/models/category.dart';

var categories = {
  Categories.vegetables: Category(
    title: 'Vegetables',
    color: Color.fromARGB(255, 0, 255, 128),
  ),
  Categories.meat: Category(
    title: 'Meat',
    color: Color.fromARGB(255, 255, 102, 0),
  ),
  Categories.dairy: Category(
    title: 'Dairy',
    color: Color.fromARGB(255, 0, 208, 255),
  ),
  Categories.carbs: Category(
    title: 'Carbs',
    color: Color.fromARGB(255, 0, 60, 255),
  ),
  Categories.sweets: Category(
    title: 'Sweets',
    color: Color.fromARGB(255, 255, 149, 0),
  ),
  Categories.spices: Category(
    title: 'Spices',
    color: Color.fromARGB(255, 255, 187, 0),
  ),
  Categories.convenience: Category(
    title: 'Convenience',
    color: Color.fromARGB(255, 191, 0, 255),
  ),
  Categories.hygiene: Category(
    title: 'Hygiene',
    color: Color.fromARGB(255, 149, 0, 255),
  )
};
