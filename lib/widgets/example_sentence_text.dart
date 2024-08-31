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
    // return _buildHtmlContent();
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

  _buildHtmlContent() => Html(
        data: """
<ruby>授業<rt>じゅぎょう</rt></ruby><ruby>の<rt></rt></ruby><ruby>終<rt>お</rt></ruby><ruby>わり<rt></rt></ruby><ruby>の<rt></rt></ruby><ruby>チャイム<rt></rt></ruby><ruby>が<rt></rt></ruby><ruby>鳴<rt>な</rt></ruby><ruby>る<rt></rt></ruby><span class="fancy"><ruby>が<rt></rt></ruby><ruby>早<rt>はや</rt></ruby><ruby>いか<rt></rt></ruby></span>、<ruby>彼<rt>かれ</rt></ruby><ruby>は<rt></rt></ruby><ruby>教室<rt>きょうしつ</rt></ruby><ruby>を<rt></rt></ruby><ruby>飛<rt>と</rt></ruby><ruby>び<rt></rt></ruby><ruby>出<rt>だ</rt></ruby><ruby>して<rt></rt></ruby><ruby>いった<rt></rt></ruby>
        """,
        extensions: [
          TagExtension(
            tagsToExtend: {"flutter"},
            child: const FlutterLogo(),
          ),
        ],
        style: {
          "span.fancy": Style(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        },
      );
}
