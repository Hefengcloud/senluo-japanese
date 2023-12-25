import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../repos/gojuon/models/models.dart';

class KanaCardView extends StatelessWidget {
  final Kana kana;
  const KanaCardView({super.key, required this.kana});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Gap(16),
          Text(
            kana.hiragana,
            style: TextStyle(fontSize: 24),
          ),
          const Gap(8),
          Text(
            kana.romaji,
            style: TextStyle(fontSize: 18),
          ),
          const Gap(16),
        ],
      ),
    );
  }
}
