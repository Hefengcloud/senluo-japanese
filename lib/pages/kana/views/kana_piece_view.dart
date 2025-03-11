import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../repos/gojuon/models/models.dart';

class KanaPieceView extends StatelessWidget {
  static const _kanaFontSize = 24.0;

  final Kana kana;
  final KanaType type;

  const KanaPieceView({
    super.key,
    required this.kana,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return kana != Kana.empty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Gap(8),
              _buildKana(),
              const Gap(8),
              _buildRomaji(),
              const Gap(8),
            ],
          )
        : const SizedBox.shrink();
  }

  Text _buildRomaji() {
    return Text(
      kana.romaji,
      style: const TextStyle(fontSize: 14, color: Colors.black26),
    );
  }

  Row _buildKana() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (type == KanaType.hiragana || type == KanaType.all)
          Text(
            kana.hiragana,
            style: GoogleFonts.kleeOne(
              fontSize: _kanaFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (type == KanaType.katakana || type == KanaType.all)
          Text(
            kana.katakana,
            style: GoogleFonts.kleeOne(
              fontSize:
                  type == KanaType.all ? _kanaFontSize - 4 : _kanaFontSize,
              fontWeight: type == KanaType.katakana
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: type == KanaType.all ? Colors.black54 : Colors.black,
            ),
          ),
      ],
    );
  }
}
