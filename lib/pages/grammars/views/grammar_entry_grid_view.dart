import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:senluo_bunpo/senluo_bunpo.dart';
import 'package:senluo_common/senluo_common.dart';

class GrammarEntryGridView extends StatelessWidget {
  final List<GrammarEntry> entries;

  final Function(GrammarEntry entry) onItemClicked;

  const GrammarEntryGridView({
    super.key,
    required this.entries,
    required this.onItemClicked,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      childAspectRatio: 3,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: entries.mapIndexed<Widget>((index, entry) {
        return ListTile(
          leading: Text(
            (index + 1).toString(),
            style: const TextStyle(fontSize: 20),
          ),
          tileColor: kLevel2color[entry.level]?.withAlpha(20),
          title: Text(
            entry.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(entry.key),
          onTap: () => onItemClicked(entry),
        );
      }).toList(),
    );
  }
}
