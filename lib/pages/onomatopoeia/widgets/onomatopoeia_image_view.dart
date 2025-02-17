import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/constants/colors.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';

import '../../../common/constants/fonts.dart';
import '../../../widgets/sentence_plain_text.dart';
import '../constants/onomatopoeia_fonts.dart';

class OnomatopoeiaImageView extends StatelessWidget {
  final Onomatopoeia item;
  final List<Example> examples;
  final double fontScaleFactor;

  const OnomatopoeiaImageView({
    super.key,
    required this.item,
    required this.examples,
    this.fontScaleFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kItemBgColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: _Header(item: item),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTitle('意思'),
              const Gap(16),
              Flexible(
                child: Text(
                  item.meanings['zh']!.join('；'),
                  style: TextStyle(
                    fontFamily: kLocalZHFont,
                    fontSize: kOnomatopoeiaBodyFontSize * fontScaleFactor,
                  ),
                ),
              ),
            ],
          ),
          const Gap(32),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _buildTitle('例句'),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    children: (examples.isNotEmpty
                            ? examples
                            : item.examples.take(2).toList())
                        .map<Widget>((e) => _buildExamples(e))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamples(Example example) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: SentencePlainText(
        lines: [example['jp']!],
        mainStyle: GoogleFonts.notoSansJp(
          fontSize: kOnomatopoeiaBodyFontSize * fontScaleFactor,
          fontWeight: FontWeight.bold,
        ),
        emphasizedColor: kItemMainColor,
      ),
      subtitle: Text(
        example['zh']!,
        style: TextStyle(
          fontFamily: kLocalZHFont,
          fontSize: kOnomatopoeiaBodyFontSize * fontScaleFactor - 2,
          color: Colors.black54,
        ),
      ),
    );
  }

  _buildTitle(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        color: kItemMainColor,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: kLocalZHFont,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.item,
  });

  final Onomatopoeia item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AutoSizeText(
            item.theName,
            style: GoogleFonts.notoSansJp(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: kItemMainColor,
            ),
            maxLines: item.name.split('/').length,
            textAlign: TextAlign.start,
          ),
        ),
        const Gap(8),
        SizedBox(
          width: 120,
          height: 120,
          child: Image.asset(
            'assets/onomatopoeia/images/${item.key}.png',
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
