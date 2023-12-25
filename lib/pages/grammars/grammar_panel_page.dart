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

class GrammarPanelPage extends StatefulWidget {
  const GrammarPanelPage({super.key});

  @override
  State<GrammarPanelPage> createState() => _GrammarPanelPageState();
}

class _GrammarPanelPageState extends State<GrammarPanelPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      final keyword = _searchController.text.trim();
      BlocProvider.of<GrammarBloc>(context)
          .add(GrammarKeywordChanged(keyword: keyword));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

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
            Expanded(
              flex: 1,
              child: _buildGrammarListView(context, state.items),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              flex: 2,
              child: GrammarDetailView(item: state.currentItem),
            ),
          ],
        ),
    };
  }

  _buildGrammarListView(BuildContext context, List<GrammarItem> items) {
    final bloc = BlocProvider.of<GrammarBloc>(context);
    return Column(
      children: [
        GrammarLevelView(
          onLevelChanged: (level) =>
              bloc.add(GrammarLevelChanged(level: level)),
        ),
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

  _buildSearchBox(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 0.0,
        ),
        child: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: UnderlineInputBorder(),
            prefixIcon: Icon(Icons.search),
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
      explanations:
          explanation?.map<String>((e) => e.toString()).toList() ?? [],
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
