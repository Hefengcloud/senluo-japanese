import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_logo.dart';
import 'package:senluo_japanese_cms/widgets/sentence_text.dart';

class ItemDisplayView extends StatelessWidget {
  final Onomatopoeia item;
  static const _kMainColor = kColorN1;

  const ItemDisplayView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Column(
        children: [
          const Gap(32),
          Expanded(
            child: Image.asset(
              'assets/onomatopoeia/images/${item.key}.jpg',
            ),
          ),
          const Gap(32),
          Text(
            item.name,
            style: GoogleFonts.getFont('Rampart One',
                fontSize: 72, color: _kMainColor),
          ),
          const Gap(16),
          Text(
            item.meanings['en']?.join('\n') ?? '',
            textAlign: TextAlign.center,
          ),
          const Gap(32),
          ...item.examples
              .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SentenceText(
                      lines: [e['jp']!, e['en']!],
                      emphasizedColor: kColorN1,
                    ),
                  ))
              .toList(),
          const Gap(32),
          const EverJapanLogo(),
          const Gap(32),
        ],
      ),
    );
  }
}
