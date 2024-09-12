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
    var html = formated.isNotEmpty
        ? convertFormatedTextToHtml('◎ $formated')
        : convertOrginalTextToHtml('◎ $original');
    html += '<span class="translated">（$translated）</span>';
    return _buildHtmlContent(html);
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
            color: Colors.black54,
            fontSize: FontSize.medium,
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
    // Convert [kanji](reading) to <ruby>kanji<rt>reading</rt></ruby>
    text = text.replaceAllMapped(
      RegExp(r'\[(.*?)\]\((.*?)\)'),
      (match) => '<ruby>${match.group(1)}<rt>${match.group(2)}</rt></ruby>',
    );

    // Convert **text** to bold
    text = text.replaceAllMapped(
      RegExp(r'\*\*(.*?)\*\*'),
      (match) =>
          '<span class="bold"><ruby>${match.group(1)}<rt class="fake">${match.group(1)}</rt></ruby></span>',
    );

    // Wrap remaining text in ruby tags
    text = text.replaceAllMapped(
      RegExp(r'(?<=^|<\/ruby>|<\/span>)([^<]+?)(?=<ruby|<\/ruby>|<span|$)',
          multiLine: true, dotAll: true),
      (match) =>
          match
              .group(1)
              ?.split('')
              .map((ch) => '<ruby>$ch<rt class="fake">$ch</rt></ruby>')
              .join('') ??
          '',
    );

    return '$text';
  }
}
