import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/pages/grammars/helpers/grammar_helper.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';
import 'package:yaml/yaml.dart';

import 'bloc/grammar_bloc.dart';
import 'grammar_adding_page.dart';
import 'widgets/grammar_detail_view.dart';
import 'widgets/grammar_display_view.dart';
import 'widgets/grammar_level_view.dart';
import 'widgets/grammar_list_view.dart';
import 'widgets/grammar_text_view.dart';

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
            // _showAddDialog(context);
            _onPickYamlFile(context);
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
            child: GrammarAddingPage(),
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

  _onPickYamlFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['yaml', 'yml'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      final yamlString = await file.readAsString();
      final grammarItem = _parseYamlString(yamlString);
      // ignore: use_build_context_synchronously
      final bloc = BlocProvider.of<GrammarBloc>(context);
      bloc.add(GrammarItemAdded(item: grammarItem));
    } else {
      // User canceled the picker
    }
  }

  _parseYamlString(String yamlString) {
    final yamlMap = loadYaml(yamlString);
    final name = yamlMap['pattern'];
    final level = yamlMap['level'];
    final meanings = yamlMap['meanings'];
    final conjugations = yamlMap['conjugations'];
    final explanation = yamlMap['explanation'];
    final examples = yamlMap['examples'];

    final grammar = GrammarItem(
      name: name,
      level: level,
      meaning: GrammarMeaning(
        jp: meanings['jp'].map<String>((e) => e.toString()).toList(),
        cn: meanings['cn']?.map<String>((e) => e.toString()).toList() ?? [],
      ),
      conjugations: conjugations.map<String>((e) => e.toString()).toList(),
      explanations: explanation ?? [],
      examples: examples
          .map<GrammarExample>(
            (e) => GrammarExample(
              jp: e['jp'],
              cn: e['cn'] ?? '',
            ),
          )
          .toList(),
    );
    return grammar;
  }
}
