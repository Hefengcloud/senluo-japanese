import 'package:flutter/material.dart';

class GrammarConjugationText extends StatelessWidget {
  final TextStyle? textStyle;

  const GrammarConjugationText({
    super.key,
    required this.text,
    this.textStyle,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    RegExp pattern = RegExp(r'(.*?)(~~.*?~~)(.*)');
    Match? match = pattern.firstMatch(text);
    if (match != null) {
      String textBefore = match.group(1) ?? "";
      String textDeleted = match.group(2) ?? "";
      String textAfter = match.group(3) ?? "";
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: textBefore, style: textStyle),
            TextSpan(
              text: textDeleted.replaceAll('~', ''),
              style: textStyle?.copyWith(
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.white,
                decorationThickness: 2,
              ),
            ),
            TextSpan(text: textAfter, style: textStyle),
          ],
        ),
      );
    } else {
      return Text(text, style: textStyle);
    }
  }
}
