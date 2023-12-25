import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';

class GrammarLevelView extends StatefulWidget {
  final Function(String? level) onLevelChanged;

  const GrammarLevelView({super.key, required this.onLevelChanged});

  @override
  State<GrammarLevelView> createState() => _GrammarLevelViewState();
}

class _GrammarLevelViewState extends State<GrammarLevelView> {
  final _levels = [
    'N1',
    'N2',
    'N3',
    'N4',
    'N5',
    'N0',
  ];

  String? _value = 'N1';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _levels
          .map(
            (level) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4.0,
                vertical: 4.0,
              ),
              child: ChoiceChip(
                showCheckmark: false,
                label: Text(level),
                labelStyle: TextStyle(
                  color: kLevel2color[level],
                  fontWeight:
                      _value == level ? FontWeight.bold : FontWeight.normal,
                ),
                selected: _value == level,
                onSelected: (bool selected) {
                  final value = selected ? level : null;
                  widget.onLevelChanged(value);
                  setState(() {
                    _value = value;
                  });
                },
              ),
            ),
          )
          .toList(),
    );
  }
}
