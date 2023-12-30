import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../repos/onomatopoeia/models/onomatopoeia_models.dart';
import '../onomatopoeia_display_page.dart';

class ItemListView extends StatelessWidget {
  final List<Onomatopoeia> items;

  const ItemListView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 6,
      children: items.map((e) => ItemCardView(item: e)).toList(),
    );
  }
}

class ItemCardView extends StatelessWidget {
  final Onomatopoeia item;

  const ItemCardView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                item.name.split("/").join('\n'),
                style: const TextStyle(fontSize: 24.0),
              )
            ],
          ),
        ),
        onTap: () => _showDisplayDialog(context, item),
      ),
    );
  }

  _showDisplayDialog(BuildContext context, Onomatopoeia item) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SizedBox(
            width: 1000,
            height: 800,
            child: ItemDisplayPage(item: item),
          ),
        ),
      );
}
