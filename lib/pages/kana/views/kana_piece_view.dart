import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../repos/gojuon/models/models.dart';

class KanaPieceView extends StatelessWidget {
  static const _kHiraganaFont = 'Zen Maru Gothic';
  static const _kKatakanaFont = 'Zen Kaku Gothic New';

  static const _kanaFontSize = 20.0;

  final Kana kana;
  const KanaPieceView({super.key, required this.kana});

  @override
  Widget build(BuildContext context) {
    return kana != Kana.empty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Gap(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    kana.hiragana,
                    style: GoogleFonts.getFont(
                      _kHiraganaFont,
                      fontSize: _kanaFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    kana.katakana,
                    style: GoogleFonts.getFont(
                      _kKatakanaFont,
                      fontSize: _kanaFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const Gap(8),
              Text(
                kana.romaji,
                style: const TextStyle(fontSize: 20, color: Colors.black54),
              ),
              const Gap(8),
            ],
          )
        : const SizedBox.shrink();
  }
}
