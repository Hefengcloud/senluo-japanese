import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';

class GrammarMenuListView extends StatelessWidget {
  final Map<JLPTLevel, int> level2Count;
  final JLPTLevel selectedLevel;
  final Function(JLPTLevel level) onLevelSelected;

  const GrammarMenuListView({
    super.key,
    required this.selectedLevel,
    required this.onLevelSelected,
    required this.level2Count,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          initiallyExpanded: true,
          title: const Text('JLPT'),
          children: JLPTLevel.values
              .where((e) => e != JLPTLevel.none)
              .map(
                (level) => ListTile(
                  tileColor: level == selectedLevel
                      ? kLevel2color[level]?.withAlpha(50)
                      : null,
                  leading: const Icon(Icons.arrow_right),
                  title: Text(
                      "${level.name.toUpperCase()}（${level2Count[level]}）"),
                  trailing:
                      level == selectedLevel ? const Icon(Icons.check) : null,
                  onTap: () {
                    onLevelSelected(level);
                  },
                ),
              )
              .toList(),
        )
      ],
    );
  }
}
