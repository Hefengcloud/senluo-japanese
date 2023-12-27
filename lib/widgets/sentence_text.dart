import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SentenceText extends StatelessWidget {
  final List<String> lines;
  final TextStyle? style;
  final Color emphasizedColor;
  final double fontSize;

  const SentenceText({
    super.key,
    this.style,
    this.fontSize = 18,
    required this.lines,
    required this.emphasizedColor,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText.rich(
      TextSpan(
        children: [
          ..._buildFormatedText(lines[0]),
          const TextSpan(text: '\n'),
          TextSpan(
            text: "(${lines[1].replaceAll('**', '')})",
            style: TextStyle(
              color: Colors.black54,
              fontSize: fontSize - 2,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  _buildFormatedText(String text) {
    final parts = text.split('**');
    final emphasizedIndex = text.startsWith('**') ? 0 : 1;
    final spans = [];

    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == emphasizedIndex) {
        spans.add(
          TextSpan(
            text: parts[i],
            style: TextStyle(
              color: emphasizedColor,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: parts[i],
            style: TextStyle(fontSize: fontSize),
          ),
        );
      }
    }
    return spans;
  }
}
