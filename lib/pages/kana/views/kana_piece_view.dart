import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../repos/gojuon/models/models.dart';

class KanaPieceView extends StatelessWidget {
  final Kana kana;
  const KanaPieceView({super.key, required this.kana});

  @override
  Widget build(BuildContext context) {
    return kana != Kana.empty
        ? Card(
            color: Colors.green[50],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Gap(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      kana.hiragana,
                      style: const TextStyle(fontSize: 32),
                    ),
                    Text(
                      kana.katakana,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ],
                ),
                const Gap(8),
                Text(
                  kana.romaji,
                  style: const TextStyle(fontSize: 20, color: Colors.black54),
                ),
                const Gap(16),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
