import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GrammarPreviewView extends StatelessWidget {
  const GrammarPreviewView({super.key});

  static const _mainColor = Color.fromRGBO(0xEB, 0x2B, 0x92, 1);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'everjapan.com',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                color: _mainColor,
                child: const Text(
                  'JLPT N1',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Gap(16),
          Text(
            '〜に限ったことではない',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: _mainColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Gap(8),
          Text('〜だけに言えることじゃない'),
          const Gap(32),
          Text(
            '不仅是～',
            style: TextStyle(color: _mainColor),
          ),
          const Gap(32),
          Container(
            color: _mainColor,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'N + に限ったことではない',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const Gap(32),
          Text(
              'マナーが悪い若者が多いと言うが、若者 に限ったことじゃないよ 。\n虽然说有很多举止不当的年轻人，但这不仅仅是年轻人的问题。'),
          Text('インフルエンザが流行ったのは、今年 に限ったことじゃない 。\n流感流行不仅仅局限于今年。'),
        ],
      ),
    );
  }
}
