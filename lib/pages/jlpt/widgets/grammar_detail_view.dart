import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/pages/jlpt/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/jlpt/constants/texts.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';
import 'package:senluo_japanese_cms/widgets/sentence_text.dart';

class GrammarDetailView extends StatelessWidget {
  const GrammarDetailView({
    super.key,
    required this.item,
    this.onGenerateImage = _defaultGenerateImage,
    this.onGenerateText = _defaultGenerateText,
  });

  final GrammarItem item;

  final Function(GrammarItem) onGenerateImage;
  final Function(GrammarItem) onGenerateText;

  // Default function for generating an image
  static void _defaultGenerateImage(GrammarItem item) {
    // Implement default behavior here
  }

  // Default function for generating text
  static void _defaultGenerateText(GrammarItem item) {
    // Implement default behavior here
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ListView(
            children: [
              _buildTitle(context, kTitleJpMeaning),
              Text(item.meaning.jp.map((e) => "・ $e").toList().join('\n')),
              const Gap(32),
              _buildTitle(context, kTitleCnMeaning),
              Text(item.meaning.cn.map((e) => "・ $e").toList().join('\n')),
              const Gap(32),
              _buildTitle(context, kTitleConjugations),
              Text(item.conjugations.map((e) => "・ $e").toList().join('\n')),
              if (item.explanations.isNotEmpty) ...[
                const Gap(32),
                _buildTitle(context, kTitleExplanation),
                Text(item.explanations.map((e) => "・ $e").toList().join('\n')),
              ],
              const Gap(32),
              _buildTitle(context, kTitleExample),
              ...item.examples
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: SentenceText(
                        prefixText: '・',
                        lines: [e.jp, e.cn],
                        emphasizedColor: kColorN1,
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
          Positioned(
            bottom: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton.icon(
                  onPressed: () => onGenerateImage(item),
                  icon: const Icon(Icons.image_outlined),
                  label: const Text('Generate Image'),
                ),
                const Gap(16),
                OutlinedButton.icon(
                  onPressed: () => onGenerateText(item),
                  icon: const Icon(Icons.abc_outlined),
                  label: const Text('Generate Text'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildTitle(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4.0),
      padding: const EdgeInsets.only(bottom: 4.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.black12),
        ),
      ),
      child: Text(
        style: Theme.of(context).textTheme.titleSmall,
        text,
      ),
    );
  }
}
