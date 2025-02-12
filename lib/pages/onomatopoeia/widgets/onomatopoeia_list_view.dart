import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/constants/colors.dart';

import '../../../repos/onomatopoeia/models/onomatopoeia_models.dart';
import '../onomatopoeia_preview_page.dart';

class OnomatopoeiaListView extends StatelessWidget {
  final List<Onomatopoeia> items;

  const OnomatopoeiaListView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) =>
            _ItemCard(index: index, item: items[index]),
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(height: 1),
        itemCount: items.length,
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final int index;
  final Onomatopoeia item;

  const _ItemCard({
    required this.index,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: AutoSizeText(
        item.name,
        style: const TextStyle(
          fontSize: 24.0,
          color: kItemMainColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(item.meanings['zh']?.join(' / ') ?? ''),
      onTap: () => _showDisplayDialog(context, item),
      trailing: const Icon(Icons.arrow_right),
    );
  }

  _showDisplayDialog(BuildContext context, Onomatopoeia item) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return OnomatopoeiaPreviewPage(item: item);
          },
        ),
      );
}
