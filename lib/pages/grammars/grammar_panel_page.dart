import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';
import 'package:yaml/yaml.dart';

import 'bloc/grammar_bloc.dart';
import 'widgets/grammar_detail_view.dart';
import 'widgets/grammar_level_view.dart';
import 'widgets/grammar_list_view.dart';

class GrammarPanelPage extends StatelessWidget {
  const GrammarPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrammarBloc, GrammarState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('JLPT 文法'),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  _buildBody(BuildContext context, GrammarState state) {
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
              child: GrammarDetailView(
                item: state.currentItem,
              ),
            ),
          ],
        ),
    };
  }

  _buildGrammarListView(BuildContext context, List<GrammarItem> items) {
    final bloc = BlocProvider.of<GrammarBloc>(context);
    return Column(
      children: [
        GrammarLevelView(),
        _buildSearchBox(context),
        GrammarListView(
          items: items,
          onItemSelected: (item) => bloc.add(GrammarItemSelected(item: item)),
          onItemDelete: (item) => bloc.add(GrammarItemDeleted(item: item)),
        ),
        IconButton.filled(
          onPressed: () => _onPickYamlFile(context),
          icon: const Icon(Icons.add),
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
