import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:markdown/markdown.dart' as md;

class JapaneseSentence extends StatelessWidget {
  final String japanese;
  final String translation;

  final String prefix;
  final bool showRuby;
  final double fontSize;
  final Color emphasizedColor;

  const JapaneseSentence({
    super.key,
    required this.japanese,
    required this.fontSize,
    required this.emphasizedColor,
    required this.translation,
    this.prefix = '',
    this.showRuby = true,
  });

  @override
  Widget build(BuildContext context) {
    String text = _markdownToHtml(japanese);
    if (translation.isNotEmpty) {
      text = "${_addMockRuby(prefix)}$text${_formatTranslation(translation)}";
    }
    return _buildHtmlContent(text);
  }

  String _formatTranslation(String text) {
    return '<span class="translated">${_addMockRuby(" / $text")}</span>';
  }

  String _addMockRuby(String text) {
    return text
        .split('')
        .map<String>((ch) => "<ruby>$ch<rt class='fake'>$ch</rt></ruby>")
        .join();
  }

  String _markdownToHtml(String markdownText) {
    // 预处理 Markdown 文本
    String preprocessed = _parseRubyTags(markdownText);

    // 使用 markdown 包转换为 HTML
    var html = md.markdownToHtml(preprocessed,
        extensionSet: md.ExtensionSet.gitHubFlavored);

    return html;
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
            .map((ch) =>
                ch != '*' ? '<ruby>$ch<rt class="fake">$ch</rt></ruby>' : ch)
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
          .map((ch) =>
              ch != '*' ? '<ruby>$ch<rt class="fake">$ch</rt></ruby>' : ch)
          .join(''));
    }

    return buffer.toString();
  }

  _buildHtmlContent(String data) => Html(
        data: data,
        extensions: [
          TagExtension(
            tagsToExtend: {"flutter"},
            child: const FlutterLogo(),
          ),
        ],
        style: _buildStyle(),
      );
  _buildStyle() => {
        'body': Style(
          fontSize: FontSize(fontSize),
          fontFamily: 'NotoSansJP', // 使用支持日文的字体
          lineHeight: const LineHeight(1.5), // 调整行高，确保对齐
        ),
        'p': Style(
          display: Display.inline,
        ),
        'strong': Style(
          color: emphasizedColor,
        ),
        'span.bold': Style(
          color: emphasizedColor,
          fontWeight: FontWeight.bold,
        ),
        '.translated': Style(
          color: Colors.black54,
        ),
        'ruby': Style(
          display: Display.inlineBlock, // 确保 Ruby 作为内联块元素
          verticalAlign: VerticalAlign.middle, // 调整垂直对齐
          fontSize: FontSize(fontSize), // 汉字大小
        ),
        'rt': Style(
          fontSize: FontSize(fontSize / 1.5), // 假名较小（约 2/3 汉字大小）
          color: Colors.grey,
          verticalAlign: VerticalAlign.top, // 假名顶部对齐
          lineHeight: const LineHeight(0.5), // 调整假名行高，减少高度影响
        ),
        'rt.fake': Style(
          color: Colors.transparent,
        ),
      };
}
