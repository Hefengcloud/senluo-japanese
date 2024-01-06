import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';

class GrammarMenuListView extends StatefulWidget {
  final Function(JLPTLevel level) onLevelSelected;

  const GrammarMenuListView({
    super.key,
    required this.onLevelSelected,
  });

  @override
  State<GrammarMenuListView> createState() => _GrammarMenuListViewState();
}

class _GrammarMenuListViewState extends State<GrammarMenuListView> {
  JLPTLevel? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          initiallyExpanded: true,
          title: const Text('JLPT'),
          children: JLPTLevel.values
              .where((e) => e != JLPTLevel.none)
              .map((level) => ListTile(
                  tileColor: level == _selectedItem
                      ? kLevel2color[level.name.toUpperCase()]?.withAlpha(50)
                      : null,
                  leading: const Icon(Icons.arrow_right),
                  title: Text(level.name.toUpperCase()),
                  trailing:
                      level == _selectedItem ? const Icon(Icons.check) : null,
                  onTap: () {
                    setState(() {
                      _selectedItem = level;
                    });
                    widget.onLevelSelected(level);
                  }))
              .toList(),
        )
      ],
    );
  }
}
