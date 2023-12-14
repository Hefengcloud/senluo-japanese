import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/pages/jlpt/bloc/grammar_bloc.dart';
import 'package:senluo_japanese_cms/pages/jlpt/helpers/grammar_helper.dart';
import 'package:senluo_japanese_cms/pages/jlpt/widgets/grammar_detail_view.dart';
import 'package:senluo_japanese_cms/pages/jlpt/widgets/grammar_level_view.dart';
import 'package:senluo_japanese_cms/pages/jlpt/widgets/grammar_list_view.dart';
import 'package:senluo_japanese_cms/pages/jlpt/widgets/grammar_text_view.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

import 'widgets/grammar_adding_view.dart';
import 'widgets/grammar_image_view.dart';

class GrammarPanelPage extends StatelessWidget {
  const GrammarPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('文法'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'JLPT'),
              Tab(text: 'Bunpo'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildJLPT(context),
            _buildBunpo(context),
          ],
        ),
      ),
    );
  }

  _buildBunpo(BuildContext context) {
    return Icon(Icons.coffee);
  }

  _buildJLPT(BuildContext context) {
    return BlocBuilder<GrammarBloc, GrammarState>(builder: (context, state) {
      return switch (state) {
        GrammarLoading() => const CircularProgressIndicator(),
        GrammarError() => const Text('Something went wrong!'),
        GrammarLoaded() => Row(
            children: [
              SizedBox(
                width: 260,
                child: _buildGrammarListView(context, state.items),
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(
                child: Container(
                  child: GrammarDetailView(
                    item: state.currentItem,
                    onGenerateImage: (item) =>
                        _showImagePreviewDialog(context, item),
                    onGenerateText: (item) => _showTextDialog(context, item),
                  ),
                ),
              ),
            ],
          ),
      };
    });
  }

  _buildGrammarListView(BuildContext context, List<GrammarItem> items) {
    return Column(
      children: [
        GrammarLevelView(),
        _buildSearchBox(context),
        GrammarListView(
          items: items,
          onItemSelected: (item) => BlocProvider.of<GrammarBloc>(context)
              .add(GrammarItemSelected(item: item)),
        ),
        ElevatedButton(
          onPressed: () {
            _showAddDialog(context);
          },
          child: const Text('Add Grammar'),
        ),
        const Gap(16),
      ],
    );
  }

  _buildSearchBox(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 0.0,
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            border: OutlineInputBorder(),
          ),
        ),
      );

  _showAddDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const AlertDialog(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          content: SizedBox(
            width: 500,
            child: GrammarAddingView(),
          ),
        );
      },
    );
  }

  _showTextDialog(BuildContext context, GrammarItem item) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: GrammarTextView(item: item),
        actions: [
          OutlinedButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: item.text));
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy'),
          )
        ],
      ),
    );
  }

  _showImagePreviewDialog(BuildContext context, GrammarItem item) {
    final imageView = GrammarImageView(item: item);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: imageView,
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
      fileName: 'image.jpg',
    );

    if (outputFile != null) {
      File file = File(outputFile);
      file.writeAsBytes(bytes);
    }
  }
}
