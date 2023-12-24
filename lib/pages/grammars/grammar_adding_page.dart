import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaml/yaml.dart';

import '../../repos/grammars/models/grammar_item.dart';
import 'bloc/grammar_bloc.dart';

class GrammarAddingPage extends StatefulWidget {
  const GrammarAddingPage({super.key});

  @override
  State<GrammarAddingPage> createState() => _GrammarAddingPageState();
}

class _GrammarAddingPageState extends State<GrammarAddingPage> {
  @override
  Widget build(BuildContext context) {
    return _buildUI(context);
  }

  _buildUI(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          onPressed: () {
            _onPickYamlFile(context);
          },
          child: const Text('Import from Yaml File'),
        ),
      ],
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
      meaning: GrammarMeaning(jp: meanings['jp'], cn: meanings['cn']),
      conjugations: conjugations.map<String>((e) => e.toString()).toList(),
      explanations: explanation ?? [],
      examples: examples
          .map<GrammarExample>(
            (e) => GrammarExample(
              jp: e['jp'],
              cn: e['cn'],
            ),
          )
          .toList(),
    );
    return grammar;
  }
}
