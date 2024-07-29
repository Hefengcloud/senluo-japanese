import 'package:flutter/material.dart';

class ExampleSentenceText extends StatelessWidget {
  final List<String> lines;
  final Color emphasizedColor;
  final TextStyle mainStyle;

  static const _kDefaultMainStyle = TextStyle(
    fontSize: 16,
  );

  const ExampleSentenceText({
    super.key,
    required this.lines,
    required this.emphasizedColor,
    this.mainStyle = _kDefaultMainStyle,
  }) : assert(lines.length >= 1);

  @override
  build(BuildContext context) {
    final List<InlineSpan> spans = [];
    for (var i = 0; i < lines.length; i++) {
      spans.addAll(_buildLine(lines[i].trim()));
      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }
    return Text.rich(
      TextSpan(
        children: spans,
      ),
    );
  }

  List<TextSpan> _buildLine(String text) {
    var parts = text.split('**');
    final emphasizedIndex = text.startsWith('**') ? 0 : 1;
    final spans = <TextSpan>[];
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
