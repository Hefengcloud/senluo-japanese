import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SentenceText extends StatelessWidget {
  final List<String> lines;
  final TextStyle? style;
  final Color emphasizedColor;
  final double fontSize;
  final TextAlign? textAlign;
  final bool multipleLines;

  const SentenceText({
    super.key,
    this.style,
    this.fontSize = 18,
    required this.lines,
    required this.emphasizedColor,
    this.textAlign,
    this.multipleLines = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          ..._buildMainText(lines[0]),
          if (multipleLines) const TextSpan(text: '\n\n'),
          _buildTranslatedText(
              "${multipleLines ? '' : '（'}${lines[1]}${multipleLines ? '' : '）'}"),
          const TextSpan(text: '\n\n'),
          if (lines.length > 2) _buildTranslatedText(lines[2])
        ],
      ),
      textAlign: textAlign,
    );
  }

  _buildTranslatedText(String text) => TextSpan(
        text: text.replaceAll('**', ''),
        style: TextStyle(
          color: Colors.black54,
          fontSize: fontSize - 2,
        ),
      );

  _buildMainText(String text) {
    var parts = text.split('**');
    final emphasizedIndex = text.startsWith('**') ? 0 : 1;
    final spans = [];
    if (emphasizedIndex == 0) {
      parts = parts.sublist(1);
    }
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
