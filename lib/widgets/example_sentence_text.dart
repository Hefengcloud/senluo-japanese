import 'package:flutter/material.dart';

class ExampleSentenceText extends StatelessWidget {
  final List<String> lines;
  final Color emphasizedColor;
  final TextStyle mainStyle;
  final TextStyle secondaryStyle;
  final bool multipleLines;

  static const _kDefaultMainStyle = TextStyle(
    fontSize: 32,
  );

  static const _kDefaultSecondaryStyle = TextStyle(
    fontSize: 24,
    color: Colors.black54,
  );

  const ExampleSentenceText({
    super.key,
    required this.lines,
    required this.emphasizedColor,
    this.mainStyle = _kDefaultMainStyle,
    this.secondaryStyle = _kDefaultSecondaryStyle,
    this.multipleLines = false,
  }) : assert(lines.length >= 2);

  @override
  Widget build(BuildContext context) {
    final mainLine = lines.first;

    return Text.rich(
      TextSpan(
        children: [
          ..._buildMainText(mainLine),
          if (multipleLines) const TextSpan(text: '\n\n'),
          _buildTranslatedText(
              "${multipleLines ? '' : '（'}${lines[1]}${multipleLines ? '' : '）'}"),
          const TextSpan(text: '\n\n'),
          if (lines.length > 2) _buildTranslatedText(lines[2]),
        ],
      ),
    );
  }

  _buildTranslatedText(String text) => TextSpan(
        text: text.replaceAll('**', ''),
        style: secondaryStyle,
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
            style: mainStyle.copyWith(
              color: emphasizedColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: parts[i],
            style: mainStyle,
          ),
        );
      }
    }
    return spans;
  }
}
