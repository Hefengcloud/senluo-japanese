import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';
import 'package:senluo_japanese_cms/constants/colors.dart';

class KanjiNavigationView extends StatelessWidget {
  final Function(JLPTLevel level) onLevelChanged;
  final JLPTLevel currentLevel;

  const KanjiNavigationView({
    super.key,
    required this.currentLevel,
    required this.onLevelChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const ListTile(
          title: Text(
            'JLPT',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: kBrandColor,
            ),
          ),
        ),
        ...JLPTLevel.values
            .where((e) => e != JLPTLevel.none)
            .toList()
            .map(
              (e) => ListTile(
                leading: const Icon(Icons.arrow_right),
                trailing: currentLevel == e ? const Icon(Icons.check) : null,
                title: Text(e.name.toUpperCase()),
                onTap: () => onLevelChanged(e),
              ),
            )
            .toList()
      ],
    );
  }
}
