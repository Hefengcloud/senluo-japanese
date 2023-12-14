import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/pages/jlpt/widgets/grammar_preview_view.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

class GrammarDetailView extends StatelessWidget {
  const GrammarDetailView({super.key, required this.item});

  final GrammarItem item;

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
                  builder: (context) => const AlertDialog(
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
              // Japanse Meaning
              Text(
                style: Theme.of(context).textTheme.titleMedium,
                "Japanese Meaning",
              ),
              Container(
                margin: const EdgeInsets.only(top: 8.0),
                child: Text(item.jpMeanings.join('\n')),
              ),
              const Gap(16),
              const Divider(),
              Text(
                style: Theme.of(context).textTheme.titleMedium,
                "Chinese Meaning",
              ),
              Container(
                margin: const EdgeInsets.only(top: 8.0),
                child: Text(item.cnMeanings.join('\n')),
              ),
              const Gap(16),
              Text(
                style: Theme.of(context).textTheme.titleMedium,
                "English Meaning",
              ),
              const Gap(16),
              Text(
                style: Theme.of(context).textTheme.titleMedium,
                "Conjugation",
              ),
              const Gap(16),
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
