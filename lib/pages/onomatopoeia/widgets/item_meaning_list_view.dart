import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../repos/onomatopoeia/models/onomatopoeia_models.dart';
import '../../../widgets/everjapan_logo.dart';
import '../../grammars/constants/texts.dart';
import 'item_title_view.dart';

class ItemMeaningListView extends StatelessWidget {
  final Onomatopoeia item;
  final Color mainColor;
  final double fontSize;

  const ItemMeaningListView({
    super.key,
    required this.item,
    required this.mainColor,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Card(
        child: Column(
          children: [
            _buildTitle(),
            _buildItemMeaning(
              kFlagJp,
              item.meanings['jp'] ?? [],
              Colors.red,
            ),
            _buildItemMeaning(
              kFlagZh,
              item.meanings['zh'] ?? [],
              Colors.green,
            ),
            _buildItemMeaning(
              kFlagEn,
              item.meanings['en'] ?? [],
              Colors.blue,
            ),
            const Gap(16),
            const EverJapanLogo(),
            const Gap(32),
          ],
        ),
      ),
    );
  }

  Padding _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ItemTitleView(
        title: item.name,
        caption: '意思',
        mainColor: mainColor,
      ),
    );
  }

  Expanded _buildItemMeaning(
    String title,
    List<String> meanings,
    Color color,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ItemMeaningView(
          title: title,
          meanings: meanings,
          color: color,
          fontSize: fontSize,
        ),
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
            alignment: Alignment.centerLeft,
            child: _buildTitle(),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16.0),
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
                  .map((e) => ListTile(
                        leading: const Text(''),
                        title: AutoSizeText(
                          e,
                          style: TextStyle(fontSize: fontSize),
                        ),
                      ))
                  .toList()
            ],
          ),
        ),
      ],
    );
  }

  _buildTitle() => Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withAlpha(120),
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(child: Text(title)),
      );
}
