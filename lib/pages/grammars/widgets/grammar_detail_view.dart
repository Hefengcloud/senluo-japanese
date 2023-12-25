import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/pages/grammars/widgets/grammar_display_view.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';
import 'package:senluo_japanese_cms/widgets/sentence_text.dart';

import '../constants/texts.dart';

typedef GrammarGenerateCallback = void Function(GrammarItem item);

class GrammarDetailView extends StatefulWidget {
  const GrammarDetailView({
    super.key,
    required this.item,
    this.onGenerateText = _defaultGenerateText,
  });

  final GrammarItem item;

  final GrammarGenerateCallback onGenerateText;

  // Default function for generating text
  static void _defaultGenerateText(GrammarItem item) {
    // Implement default behavior here
  }

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
          ListView(
            children: [
              _buildTitle(context, kTitleJpMeaning),
              Text(widget.item.meaning.jp
                  .map((e) => "・ $e")
                  .toList()
                  .join('\n')),
              const Gap(32),
              _buildTitle(context, kTitleCnMeaning),
              Text(widget.item.meaning.cn
                  .map((e) => "・ $e")
                  .toList()
                  .join('\n')),
              const Gap(32),
              _buildTitle(context, kTitleConjugations),
              Text(widget.item.conjugations
                  .map((e) => "・ $e")
                  .toList()
                  .join('\n')),
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
          Positioned(
            bottom: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _display(
                    context,
                    widget.item,
                    _selectedExamples,
                  ),
                  icon: const Icon(Icons.image_outlined),
                  label: const Text('Generate Image'),
                ),
                const Gap(16),
                OutlinedButton.icon(
                  onPressed: () => widget.onGenerateText(widget.item),
                  icon: const Icon(Icons.abc_outlined),
                  label: const Text('Generate Text'),
                ),
              ],
            ),
          )
        ],
      ),
    );
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
        style: Theme.of(context).textTheme.titleSmall,
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

  _display(
    BuildContext context,
    GrammarItem item,
    List<GrammarExample> examples,
  ) {
    final imageView = GrammarDisplayView(
      item: item,
      examples: examples,
    );
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(width: 600, child: imageView),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton.icon(
            onPressed: () async {
              final bytes = await imageView.captureWidget();
              if (bytes != null) {
                _saveImageToFile(bytes);
              }
            },
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
          CloseButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  _saveImageToFile(Uint8List bytes) async {
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String appDocPath = appDocDir.path;
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: 'grammar.jpg',
    );

    if (outputFile != null) {
      File file = File(outputFile);
      file.writeAsBytes(bytes);
    }
  }
}
