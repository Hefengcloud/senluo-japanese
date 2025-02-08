import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';

import '../../../repos/grammars/models/grammar_entry.dart';

class GrammarMenuListView extends StatelessWidget {
  final Map<JLPTLevel, List<GrammarEntry>> grammarsByLevel;

  final Function(GrammarEntry entry) onEntrySelected;

  const GrammarMenuListView({
    super.key,
    required this.onEntrySelected,
    required this.grammarsByLevel,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          initiallyExpanded: true,
          title: const Text(
            "JLPT",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: JLPTLevel.values
              .where((e) => e != JLPTLevel.none)
              .map<ExpansionTile>(
                (level) => ExpansionTile(
                    title: Text(level.name.toUpperCase()),
                    initiallyExpanded: false,
                    children: (grammarsByLevel[level] ?? [])
                        .map<ListTile>((e) => ListTile(
                              leading: const Icon(Icons.arrow_right),
                              title: Text(e.name),
                              onTap: () => onEntrySelected(e),
                            ))
                        .toList()),
              )
              .toList(),
        ),
      ],
    );
  }
}
