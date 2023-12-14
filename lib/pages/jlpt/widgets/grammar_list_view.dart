import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

class GrammarListView extends StatelessWidget {
  final Function(GrammarItem) onItemSelected;

  final List<GrammarItem> items;

  GrammarListView({
    super.key,
    required this.items,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (ctx, idx) => ListTile(
          title: Text(items[idx].title),
          onTap: () => onItemSelected(items[idx]),
        ),
        separatorBuilder: (ctx, idx) => const Divider(),
        itemCount: items.length,
      ),
    );
  }
}
