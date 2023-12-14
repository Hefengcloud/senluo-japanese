import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/pages/jlpt/widgets/grammar_preview_view.dart';

class GrammarDetailView extends StatelessWidget {
  const GrammarDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Positioned(
            right: 16.0,
            bottom: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: GrammarPreviewView(),
                  ),
                );
              },
              child: const Icon(Icons.share),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                style: Theme.of(context).textTheme.titleMedium,
                "Japanese Meaning",
              ),
              Container(
                margin: EdgeInsets.only(top: 8.0),
                child: Text('〜があるから・・・が成り立つ\n〜がなかったら、・・・が成り立たない'),
              ),
              Gap(16),
              Text(
                style: Theme.of(context).textTheme.titleMedium,
                "Chinese Meaning",
              ),
              Container(
                margin: EdgeInsets.only(top: 8.0),
                child: Text('有〜才〜\n没有〜就不能（没有）〜'),
              ),
              Gap(16),
              Text(
                style: Theme.of(context).textTheme.titleMedium,
                "English Meaning",
              ),
              Gap(16),
              Text(
                style: Theme.of(context).textTheme.titleMedium,
                "Conjugation",
              ),
              Gap(16),
              Text(
                style: Theme.of(context).textTheme.titleMedium,
                "Examples",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
