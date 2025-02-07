import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/common/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/constants/constants.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_caption_view.dart';

import '../../../../repos/onomatopoeia/models/onomatopoeia_models.dart';
import '../item_title_view.dart';

class ItemMeaningsPreviewView extends StatelessWidget {
  final Onomatopoeia item;
  final double fontSizeScaleFactor;

  const ItemMeaningsPreviewView({
    super.key,
    required this.item,
    required this.fontSizeScaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        const Gap(16),
        Expanded(
          child: _buildMeaningList(item.meanings),
        ),
      ],
    );
  }

  Padding _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ItemTitleView(
        title: item.theName,
        subtitle: '意味',
        mainColor: kItemMainColor,
      ),
    );
  }

  _buildMeaningList(Meaning meanings) {
    return ListView(
      children: meanings.entries.map(
        (e) {
          var textLines = e.value;
          if (e.value.length > 1) {
            textLines =
                e.value.mapIndexed((idx, e) => "${idx + 1}) $e").toList();
          }
          return ListTile(
            leading: Text(
              e.key.toUpperCase(),
            ),
            title: Text(
              textLines.join('\n'),
              style: TextStyle(
                fontFamily: kZhFont,
                fontSize: kBodyFontSize * fontSizeScaleFactor,
                color: kBrandColor,
              ),
            ),
          );
        },
      ).toList(),
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
    this.fontSize = 16,
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
          padding: const EdgeInsets.only(top: 16),
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
              ...meanings.map(
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
            ],
          ),
        ),
      ],
    );
  }
}
