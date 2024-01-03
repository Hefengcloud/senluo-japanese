import 'package:flutter/material.dart';

import '../../../repos/gojuon/models/models.dart';

class KanaDisplayView extends StatelessWidget {
  final Kana kana;
  const KanaDisplayView({super.key, required this.kana});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          kana.hiragana,
          style: TextStyle(fontSize: 96),
        ),
      ],
    );
  }
}
