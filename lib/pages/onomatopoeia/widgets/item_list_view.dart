import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';

class ItemListView extends StatelessWidget {
  final List<Onomatopoeia> items;

  const ItemListView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 6,
      children: items.map((e) => Text(e.name)).toList(),
    );
  }
}
