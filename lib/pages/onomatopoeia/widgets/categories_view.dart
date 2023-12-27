import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/category_model.dart';

class CategoriesView extends StatelessWidget {
  final List<OnomatopoeiaCategory> categories;

  const CategoriesView({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: categories.map((e) => Text(e.name)).toList(),
    );
  }
}
