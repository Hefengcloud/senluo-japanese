import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

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
    return _buildHtmlContent(lines[0]);
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

  _buildHtmlContent(String text) => Html(
        data: convertToHtml(text),
        extensions: [
          TagExtension(
            tagsToExtend: {"flutter"},
            child: const FlutterLogo(),
          ),
        ],
        style: {
          "span.bold": Style(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
          "rt.fake": Style(
            color: Colors.transparent,
          )
        },
      );

  // String _convertToRuby(String text) {
  //   // First, handle the [kanji](kana) patterns
  //   RegExp rubyExp = RegExp(r'\[([^\]]+)\]\(([^\)]+)\)');
  //   String htmlText = text.replaceAllMapped(rubyExp, (Match m) {
  //     String kanji = m.group(1)!;
  //     String kana = m.group(2)!;
  //     return '<ruby>$kanji<rt>$kana</rt></ruby>';
  //   });

  //   // Then, handle the **text** patterns
  //   RegExp boldExp = RegExp(r'\*\*([^*]+)\*\*');
  //   htmlText = htmlText.replaceAllMapped(boldExp, (Match m) {
  //     String boldText = m.group(1)!;
  //     return '<span class="fancy">$boldText</span>';
  //   });

  //   return '<p>$htmlText</p>';
  // }

  String convertToHtml(String text) {
    List<String> parts = [];
    RegExp rubyExp = RegExp(r'\[([^\]]+)\]\(([^\)]+)\)');
    RegExp boldExp = RegExp(r'\*\*([^*]+)\*\*');

    int lastIndex = 0;
    for (Match match in rubyExp.allMatches(text)) {
      if (match.start > lastIndex) {
        parts.add(text.substring(lastIndex, match.start));
      }
      parts.add(match.group(0)!);
      lastIndex = match.end;
    }
    if (lastIndex < text.length) {
      parts.add(text.substring(lastIndex));
    }

    List<String> htmlParts = parts.map((part) {
      if (rubyExp.hasMatch(part)) {
        Match m = rubyExp.firstMatch(part)!;
        String kanji = m.group(1)!;
        String kana = m.group(2)!;
        return '<ruby>$kanji<rt>$kana</rt></ruby>';
      } else if (boldExp.hasMatch(part)) {
        String boldText = boldExp.firstMatch(part)!.group(1)!;
        return '<span class="bold">$boldText</span>';
      } else {
        return part
            .split('')
            .map((char) => '<ruby>$char<rt class="fake">$char</rt></ruby>')
            .join('');
      }
    }).toList();

    String htmlText = htmlParts.join('');
    return '<p class="japanese-text">$htmlText</p>';
  }
}
