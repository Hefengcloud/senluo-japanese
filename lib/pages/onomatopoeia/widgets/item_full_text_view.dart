import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';

import '../helpers/item_text_helper.dart';

class ItemFullTextView extends StatelessWidget {
  final Onomatopoeia item;

  const ItemFullTextView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SelectableText(generateFullText(item)),
    );
  }
}
