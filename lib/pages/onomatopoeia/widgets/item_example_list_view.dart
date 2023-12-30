import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_title_view.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_logo.dart';
import 'package:senluo_japanese_cms/widgets/sentence_text.dart';

class ItemExampleListView extends StatelessWidget {
  final Onomatopoeia item;
  final List<Example> examples;

  final Color mainColor;
  const ItemExampleListView({
    super.key,
    required this.item,
    required this.mainColor,
    this.examples = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ItemTitleView(
              title: item.name,
              caption: '例句',
              mainColor: mainColor,
            ),
          ),
          ..._getExamples()
              .map<Widget>(
                (e) => Expanded(child: _buildExample(context, e, 1)),
              )
              .toList(),
          const Gap(16),
          const Center(child: EverJapanLogo()),
          const Gap(32),
        ],
      ),
    );
  }

  _getExamples() =>
      examples.isNotEmpty ? examples : item.examples.take(3).toList();

  _buildExample(BuildContext context, Example example, int index) => Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 32.0,
            ),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.red.withAlpha(10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SentenceText(
                lines: [
                  example['jp'] ?? '',
                  example['zh'] ?? '',
                  example['en'] ?? '',
                ],
                fontSize: 22,
                emphasizedColor: mainColor,
                multipleLines: true,
              ),
            ),
          ),
        ],
      );
}
