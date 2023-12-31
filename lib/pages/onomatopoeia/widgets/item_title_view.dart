import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemTitleView extends StatelessWidget {
  final String title;
  final Color mainColor;

  const ItemTitleView({
    super.key,
    required this.title,
    required this.mainColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AutoSizeText(
          title,
          style: GoogleFonts.getFont(
            'Rampart One',
            color: mainColor,
            fontSize: 56,
          ),
        ),
        const Gap(8),
      ],
    );
  }
}
