import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:path/path.dart';
import 'package:senluo_japanese_cms/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_caption_view.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_title_view.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';
import 'package:senluo_japanese_cms/widgets/example_sentence_text.dart';
import 'package:senluo_japanese_cms/widgets/sentence_text.dart';

import '../../../../constants/texts.dart';
import '../../constants/constants.dart';

class ItemExamplesPreviewView extends StatelessWidget {
  final Onomatopoeia item;
  final List<Example> examples;
  final double fontScaleFactor;

  final Color bgColor = Colors.blue;
  const ItemExamplesPreviewView({
    super.key,
    required this.item,
    this.examples = const [],
    this.fontScaleFactor = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ItemTitleView(
            title: item.theName,
            subtitle: '例文',
            mainColor: kItemMainColor,
          ),
        ),
        const Gap(16),
        Expanded(
          child: _buildExampleList(_getExamples()),
        )
        // ..._getExamples()
        //     .map<Widget>(
        //       (e) => Expanded(child: _buildExample(context, e, 1)),
        //     )
        //     .toList(),
      ],
    );
  }

  _buildExampleList(List<Example> examples) {
    return ListView(
      children: examples
          .map(
            (e) => ListTile(
              title: ExampleSentenceText(
                mainStyle: TextStyle(
                  color: kBrandColor,
                  fontFamily: kZhFont,
                  fontSize: kBodyFontSize * fontScaleFactor,
                ),
                lines: [e['jp'] ?? ''],
                emphasizedColor: kItemMainColor,
              ),
              subtitle: Text(
                [e['zh'] ?? '', e['en'] ?? ''].join('\n'),
                style: TextStyle(
                  fontFamily: kZhFont,
                  fontSize: (kBodyFontSize - 4) * fontScaleFactor,
                ),
              ),
              tileColor: Colors.blue[50],
            ),
          )
          .toList(),
    );
  }

  _getExamples() =>
      examples.isNotEmpty ? examples : item.examples.take(3).toList();

  _buildExample(BuildContext context, Example example, int index) => Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ItemCaptionTitle(
                  title: kTitleExample,
                  bgColor: bgColor,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 8.0,
            ),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: bgColor.withAlpha(10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ExampleSentenceText(
                lines: [
                  example['jp'] ?? '',
                  example['zh'] ?? '',
                  example['en'] ?? '',
                ],
                mainStyle: TextStyle(
                  fontSize: kItemBodyTextSize * fontScaleFactor,
                ),
                secondaryStyle: TextStyle(
                  fontSize: (kItemBodyTextSize - 2) * fontScaleFactor,
                  color: Colors.black54,
                ),
                emphasizedColor: kItemMainColor,
                multipleLines: true,
              ),
            ),
          ),
        ],
      );
}
