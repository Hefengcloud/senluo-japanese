import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/constants/contants.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';

class ItemFullPreviewView extends StatelessWidget {
  final double fontSizeScaleFactor;
  final Onomatopoeia item;

  const ItemFullPreviewView({
    super.key,
    required this.item,
    this.fontSizeScaleFactor = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 128,
            bottom: 32,
          ),
          child: SizedBox(
            height: 250,
            child: Image.asset(
              'assets/onomatopoeia/images/${item.key}.png',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: _buildItemTitle(
            fontSize: kItemMainTitleSize,
          ),
        ),
        const Gap(48),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: AutoSizeText(
              item.meanings['zh']?.join('\n') ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24 * fontSizeScaleFactor,
                color: kBrandColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  AutoSizeText _buildItemTitle({double? fontSize}) {
    return AutoSizeText(
      item.name,
      style: GoogleFonts.getFont(
        'Rampart One',
        fontSize: fontSize,
        color: kItemMainColor,
      ),
      maxLines: 1,
    );
  }
}
