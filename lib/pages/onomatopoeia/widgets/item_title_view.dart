import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/constants/colors.dart';

class ItemTitleView extends StatelessWidget {
  final String title;
  final String caption;
  final Color mainColor;

  const ItemTitleView({
    super.key,
    required this.title,
    required this.caption,
    required this.mainColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AutoSizeText(
          title,
          style: GoogleFonts.getFont(
            'Rampart One',
            color: mainColor,
            fontSize: 48,
          ),
        ),
        const Gap(8),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            caption,
            style: const TextStyle(
              fontSize: 20,
              color: kColorBrand,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
