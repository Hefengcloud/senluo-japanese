import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

class GrammarListView extends StatelessWidget {
  final Function(GrammarItem) onItemSelected;
  final Function(GrammarItem) onItemDelete;

  final List<GrammarItem> items;

  const GrammarListView({
    super.key,
    required this.items,
    required this.onItemSelected,
    required this.onItemDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (ctx, idx) {
          final item = items[idx];
          return ListTile(
            title: Text(item.name),
            onTap: () => onItemSelected(item),
            subtitle: Text(
              item.level,
              style: TextStyle(color: kLevel2color[item.level]),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outlined),
              onPressed: () => _showContextMenu(context, items[idx]),
            ),
          );
        },
        separatorBuilder: (ctx, idx) => const Divider(),
        itemCount: items.length,
      ),
    );
  }

  _showContextMenu(BuildContext context, GrammarItem item) async {
    final confirmed = await showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm'),
        content: const Text('Delete this one?'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onItemDelete(item);
    }
  }
}
