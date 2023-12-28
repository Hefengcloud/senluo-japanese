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
        Text(
          title,
          style: GoogleFonts.getFont(
            'Rampart One',
            color: mainColor,
            fontSize: 64,
          ),
        ),
        const Gap(32),
        Text(
          caption,
          style: const TextStyle(
            fontSize: 20,
            color: kColorBrand,
          ),
        ),
      ],
    );
  }
}
