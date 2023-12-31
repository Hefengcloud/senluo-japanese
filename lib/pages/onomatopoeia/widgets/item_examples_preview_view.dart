import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/texts.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_title_view.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_logo.dart';
import 'package:senluo_japanese_cms/widgets/sentence_text.dart';

import '../../../constants/colors.dart';
import '../constants/contants.dart';

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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ItemTitleView(
            title: item.name,
            mainColor: kItemMainColor,
          ),
        ),
        const Gap(16),
        ..._getExamples()
            .map<Widget>(
              (e) => Expanded(child: _buildExample(context, e, 1)),
            )
            .toList(),
        const Gap(16),
        const Center(child: EverJapanLogo()),
        const Gap(32),
      ],
    );
  }

  _getExamples() =>
      examples.isNotEmpty ? examples : item.examples.take(3).toList();

  _buildExample(BuildContext context, Example example, int index) => Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: _buildTitle(kTitleExample),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: bgColor.withAlpha(10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Align(
              alignment: Alignment.center,
              child: SentenceText(
                lines: [
                  example['jp'] ?? '',
                  example['zh'] ?? '',
                  example['en'] ?? '',
                ],
                textAlign: TextAlign.center,
                fontSize: kItemBodyTextSize * fontScaleFactor,
                emphasizedColor: kItemMainColor,
                multipleLines: true,
              ),
            ),
          ),
        ],
      );

  _buildTitle(String title) => Chip(
        label: Text(
          title,
          style: const TextStyle(
            color: kBrandColor,
          ),
        ),
        side: BorderSide.none,
        backgroundColor: bgColor.withAlpha(40),
      );
}
