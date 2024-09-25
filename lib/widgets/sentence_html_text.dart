import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class SentenceHtmlText extends StatelessWidget {
  final String original;
  final String formated;
  final String translated;

  final Color emphasizedColor;
  final TextStyle mainStyle;

  static const _kDefaultMainStyle = TextStyle(
    fontSize: 16,
  );

  const SentenceHtmlText({
    super.key,
    required this.original,
    required this.formated,
    required this.translated,
    required this.emphasizedColor,
    this.mainStyle = _kDefaultMainStyle,
  });

  @override
  build(BuildContext context) {
    final isFormated = formated.isNotEmpty;
    var html = isFormated
        ? convertFormatedTextToHtml('◎ $formated')
        : convertOrginalTextToHtml('◎ $original');
    html +=
        '<span class="translated">${isFormated ? _formatTranslatedText("（$translated）") : "（$translated）"}</span>';
    return _buildHtmlContent(html);
  }

  _formatTranslatedText(String text) {
    return text
        .split('')
        .map<String>((ch) => "<ruby>$ch<rt class='fake'>$ch</rt></ruby>")
        .join();
  }

  _buildHtmlContent(String data) => Html(
        data: data,
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
          ".translated": Style(
            color: Colors.black38,
          ),
          "rt": Style(
            color: Colors.black54,
          ),
          "rt.fake": Style(
            color: Colors.transparent,
          )
        },
      );

  String convertOrginalTextToHtml(String text) {
    text = text.replaceAllMapped(
      RegExp(r'\*\*(.*?)\*\*'),
      (match) => '<span class="bold">${match.group(1)}</span>',
    );
    return text;
  }

  String convertFormatedTextToHtml(String text) {
    var htmlText = '';
    final indexes = getAllIndexesOfDoubleAsterisk(text);

    final firstIndex = indexes[0];
    var subtext = text.substring(0, firstIndex);
    if (subtext.isNotEmpty) {
      htmlText += _parseRubyTags(subtext);
    }

    for (var i = 0; i < indexes.length; i += 2) {
      subtext = text.substring(indexes[i] + 2, indexes[i + 1]);
      subtext = _parseRubyTags(subtext);
      htmlText += '<span class="bold">$subtext</span>';
    }

    subtext = text.substring(indexes[indexes.length - 1] + 2, text.length);
    subtext = _parseRubyTags(subtext);
    htmlText += subtext;

    return htmlText;
  }

  String _parseRubyTags(String text) {
    // First, convert markdown-style ruby annotations to HTML ruby tags
    text = text.replaceAllMapped(
      RegExp(r'\[(.*?)\]\((.*?)\)'),
      (match) => '<ruby>${match.group(1)}<rt>${match.group(2)}</rt></ruby>',
    );

    // Then, wrap remaining text in ruby tags, but preserve existing ruby tags
    final buffer = StringBuffer();
    final existingRubyPattern = RegExp(r'<ruby>.*?<\/ruby>');
    var lastEnd = 0;

    for (final match in existingRubyPattern.allMatches(text)) {
      if (match.start > lastEnd) {
        // Process text between ruby tags
        final betweenTags = text.substring(lastEnd, match.start);
        buffer.write(betweenTags
            .split('')
            .map((ch) => '<ruby>$ch<rt class="fake">$ch</rt></ruby>')
            .join(''));
      }
      // Keep existing ruby tag as is
      buffer.write(match.group(0));
      lastEnd = match.end;
    }

    // Process any remaining text after the last ruby tag
    if (lastEnd < text.length) {
      final remainingText = text.substring(lastEnd);
      buffer.write(remainingText
          .split('')
          .map((ch) => '<ruby>$ch<rt class="fake">$ch</rt></ruby>')
          .join(''));
    }

    return buffer.toString();
  }

  // Function to get all the indexes of "**"
  List<int> getAllIndexesOfDoubleAsterisk(String str) {
    List<int> indexes = [];
    int index = str.indexOf('**');

    while (index != -1) {
      indexes.add(index);
      // Move to the next occurrence after the current one
      index = str.indexOf('**', index + 2);
    }

    return indexes;
  }
}
