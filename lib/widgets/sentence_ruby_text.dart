import 'package:flutter/material.dart';
import 'package:ruby_text/ruby_text.dart'; // 假设使用 ruby_text 包

class SentenceRubyText extends StatelessWidget {
  final String text;

  const SentenceRubyText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return RubyText(
      _buildRubyTextData(),
      style: const TextStyle(fontSize: 16, fontFamily: 'NotoSansJP'), // 使用日文字体
    );
  }

  List<RubyTextData> _buildRubyTextData() {
    List<RubyTextData> data = [];
    RegExp rubyRegex = RegExp(
        r'(\p{sc=Han}|\p{sc=Hiragana}|\p{sc=Katakana})?\[([^\]]+)\]\(([^)]+)\)'); // 匹配 [汉字](假名)，支持前缀
    RegExp boldRegex = RegExp(r'\*\*([^*]+)\*\*'); // 匹配 **文本**
    int index = 0;

    while (index < text.length) {
      Match? rubyMatch = rubyRegex.firstMatch(text.substring(index));
      Match? boldMatch = boldRegex.firstMatch(text.substring(index));

      int nextRubyIndex =
          rubyMatch != null ? index + rubyMatch.start : text.length;
      int nextBoldIndex =
          boldMatch != null ? index + boldMatch.start : text.length;
      int nextIndex =
          nextRubyIndex < nextBoldIndex ? nextRubyIndex : nextBoldIndex;

      // 处理普通文本
      if (index < nextIndex) {
        String normalText = text.substring(index, nextIndex);
        data.add(RubyTextData(normalText));
        index = nextIndex;
      }

      // 处理 Ruby 标记
      if (nextIndex == nextRubyIndex && rubyMatch != null) {
        String prefix = rubyMatch.group(1) ?? ''; // 前缀（如 `お`）
        String kanji = rubyMatch.group(2)!;
        String furigana = rubyMatch.group(3)!;
        data.addAll([
          RubyTextData(prefix), // 添加前缀（如 `お`）
          RubyTextData(
            kanji,
            ruby: furigana,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'NotoSansJP', // 确保日文显示正确
            ),
          ),
        ]);
        index += rubyMatch.end;
      }
      // 处理强调标记
      else if (nextIndex == nextBoldIndex && boldMatch != null) {
        String boldText = boldMatch.group(1)!;
        data.add(
          RubyTextData(
            boldText,
            style: const TextStyle(
              fontWeight: FontWeight.bold, // 加粗
              color: Colors.red, // 红色强调
              backgroundColor: Color(0x4DFFFF00), // 淡黄色背景
            ),
          ),
        );
        index += boldMatch.end;
      }
    }

    return data;
  }
}
