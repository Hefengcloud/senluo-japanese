import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/pages/grammars/widgets/grammar_display_view.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

import '../constants/texts.dart';

typedef GrammarExampleSelectCallback = void Function(GrammarExample item);

class GrammarDetailView extends StatefulWidget {
  const GrammarDetailView({
    super.key,
    required this.item,
  });

  final GrammarItem item;

  @override
  State<GrammarDetailView> createState() => _GrammarDetailViewState();
}

class _GrammarDetailViewState extends State<GrammarDetailView> {
  List<GrammarExample> _selectedExamples = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            children: [
              ListView(
                children: [
                  _buildTitle(context, kTitleJpMeaning),
                  ...widget.item.meaning.jp
                      .map((e) => ListTile(title: Text(e), onTap: () {}))
                      .toList(),
                  const Gap(32),
                  _buildTitle(context, kTitleCnMeaning),
                  ...widget.item.meaning.cn
                      .map((e) => ListTile(title: Text(e), onTap: () {}))
                      .toList(),
                  const Gap(32),
                  _buildTitle(context, kTitleConjugations),
                  ...widget.item.conjugations
                      .map((e) => ListTile(title: Text(e), onTap: () {}))
                      .toList(),
                  if (widget.item.explanations.isNotEmpty) ...[
                    const Gap(32),
                    _buildTitle(context, kTitleExplanation),
                    Text(widget.item.explanations
                        .map((e) => "・ $e")
                        .toList()
                        .join('\n')),
                  ],
                  const Gap(32),
                  _buildTitle(context, kTitleExample),
                  ..._buildExamples(context, widget.item.examples),
                ],
              ),
              Positioned.fill(
                bottom: 16,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton.icon(
                    onPressed: () => _showPreviewDialog(context),
                    icon: const Icon(Icons.image),
                    label: const Text('Preview'),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _showPreviewDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: 1000,
          child: GrammarDisplayView(
            item: widget.item,
            examples: _selectedExamples,
          ),
        ),
      ),
    );
    _selectedExamples = [];
  }

  _buildTitle(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4.0),
      padding: const EdgeInsets.only(bottom: 4.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.black12),
        ),
      ),
      child: Text(
        style: Theme.of(context).textTheme.titleLarge,
        text,
      ),
    );
  }

  _buildExamples(BuildContext context, examples) {
    return examples
        .map(
          (e) => Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ListTile(
              title: Text(e.jp),
              subtitle: Text(e.cn),
              trailing: _selectedExamples.contains(e)
                  ? const Icon(Icons.check_rounded)
                  : null,
              selected: _selectedExamples.contains(e),
              onTap: () {
                if (_selectedExamples.contains(e)) {
                  _selectedExamples.remove(e);
                } else {
                  _selectedExamples.add(e);
                }

                setState(() {
                  _selectedExamples = [..._selectedExamples];
                });
              },
            ),
          ),
        )
        .toList();
  }
}
