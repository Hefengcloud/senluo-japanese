import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';

import '../../../widgets/sentence_text.dart';

class OnomatopoeiaCard extends StatelessWidget {
  final Onomatopoeia item;

  const OnomatopoeiaCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          AutoSizeText(
            item.name,
            style: GoogleFonts.getFont(
              'Mochiy Pop One',
              fontSize: 64,
              color: kColorN1,
            ),
            maxLines: 1,
          ),
          const Gap(8),
          AutoSizeText(
            item.meanings['jp']!.join('\n'),
            maxLines: 2,
            textAlign: TextAlign.center,
            style: GoogleFonts.getFont(
              'Yusei Magic',
              fontSize: 20,
              color: kBrandColor,
            ),
          ),
          const Gap(16),
          SizedBox(
            height: 256,
            child: Image.asset('assets/images/onomatopoeia/${item.key}.jpg'),
          ),
          const Gap(16),
          ...item.examples.map((e) {
            return SentenceText(
              lines: [
                e['jp']!,
                e['en']!,
              ],
              emphasizedColor: kColorN1,
            );
          }),
        ],
      ),
    );
  }
}
