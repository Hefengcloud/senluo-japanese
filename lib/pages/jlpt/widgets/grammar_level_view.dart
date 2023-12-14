import 'package:flutter/material.dart';

class GrammarLevelView extends StatelessWidget {
  GrammarLevelView({super.key});

  final _levels = [
    'N1',
    'N2',
    'N3',
    'N4',
    'N5',
    'N0',
  ];

  @override
  Widget build(BuildContext context) {
    return _buildLevelFilters(context);
  }

  _buildLevelFilters(BuildContext context) {
    return Wrap(
      children: _levels
          .map(
            (e) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              child: ChoiceChip(label: Text(e), selected: false),
            ),
          )
          .toList(),
    );
  }
}
