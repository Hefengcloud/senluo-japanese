import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_display_view.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.name,
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        ),
        onTap: () => _showDisplayDialog(context, item),
      ),
    );
  }

  _showDisplayDialog(BuildContext context, Onomatopoeia item) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: ItemDisplayView(item: item),
        ),
      );
}
