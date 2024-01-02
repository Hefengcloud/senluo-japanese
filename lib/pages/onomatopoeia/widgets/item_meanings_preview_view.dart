import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_caption_view.dart';

import '../../../repos/onomatopoeia/models/onomatopoeia_models.dart';
import '../../grammars/constants/texts.dart';
import 'item_title_view.dart';

class ItemMeaningsPreviewView extends StatelessWidget {
  final Onomatopoeia item;
  final double fontSize;

  const ItemMeaningsPreviewView({
    super.key,
    required this.item,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        const Gap(16),
        _buildItemMeaning(
          kTitleZhMeaning,
          item.meanings['zh'] ?? [],
          Colors.green,
        ),
        _buildItemMeaning(
          kTitleEnMeaning,
          item.meanings['en'] ?? [],
          Colors.blue,
        ),
        _buildItemMeaning(
          kTitleJpMeaning,
          item.meanings['jp'] ?? [],
          Colors.red,
        ),
      ],
    );
  }

  Padding _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ItemTitleView(
        title: item.name,
        mainColor: kItemMainColor,
      ),
    );
  }

  Expanded _buildItemMeaning(
    String title,
    List<String> meanings,
    Color color,
  ) {
    return Expanded(
      child: ItemMeaningView(
        title: title,
        meanings: meanings,
        color: color,
        fontSize: fontSize,
      ),
    );
  }
}

class ItemMeaningView extends StatelessWidget {
  final String title;
  final List<String> meanings;
  final Color color;
  final double fontSize;

  const ItemMeaningView({
    super.key,
    required this.title,
    required this.meanings,
    required this.color,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ItemCaptionTitle(title: title, bgColor: color),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 20,
          ),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: color.withAlpha(10),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...meanings
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: AutoSizeText(
                        e,
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ),
                  )
                  .toList()
            ],
          ),
        ),
      ],
    );
  }
}
