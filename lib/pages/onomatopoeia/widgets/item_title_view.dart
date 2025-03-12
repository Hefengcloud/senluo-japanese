import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/common/constants/colors.dart';

import '../../../common/constants/fonts.dart';

class ItemTitleView extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color mainColor;

  const ItemTitleView({
    super.key,
    required this.title,
    required this.subtitle,
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
            kJpGoogleFont,
            color: mainColor,
            fontSize: title.contains('\n') ? 48 : 52,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: kBrandColor,
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.only(bottom: 16.0),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            subtitle,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
