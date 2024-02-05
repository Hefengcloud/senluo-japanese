import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/common/constants/number_constants.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/constants/colors.dart';

import '../../../repos/onomatopoeia/models/onomatopoeia_models.dart';
import '../onomatopoeia_display_page.dart';

class ItemGridView extends StatelessWidget {
  final List<Onomatopoeia> items;

  const ItemGridView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: items
            .mapIndexed((index, item) => ItemCardView(index: index, item: item))
            .toList(),
      ),
    );
  }
}

class ItemCardView extends StatelessWidget {
  final int index;
  final Onomatopoeia item;

  const ItemCardView({
    super.key,
    required this.index,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: kItemBgColor,
      trailing: Text(
        (index + 1).toString(),
        style: const TextStyle(fontSize: 24, color: Colors.grey),
      ),
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
    );
  }

  _showDisplayDialog(BuildContext context, Onomatopoeia item) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SizedBox(
            width: kPreviewDialogWidth,
            height: kPreviewDialogHeight,
            child: ItemDisplayPage(item: item),
          ),
        ),
      );
}
