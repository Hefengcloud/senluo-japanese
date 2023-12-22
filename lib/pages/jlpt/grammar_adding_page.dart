import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/pages/jlpt/bloc/grammar_bloc.dart';
import 'package:yaml/yaml.dart';

import '../../repos/grammars/models/grammar_item.dart';

class GrammarAddingPage extends StatefulWidget {
  const GrammarAddingPage({super.key});

  @override
  State<GrammarAddingPage> createState() => _GrammarAddingPageState();
}

class _GrammarAddingPageState extends State<GrammarAddingPage> {
  int _index = 0;

  final _steps = <Step>[
    Step(
      title: const Text('Japanese Meaning'),
      content: Container(
        alignment: Alignment.centerLeft,
        child: const TextField(
          maxLines: null,
        ),
      ),
    ),
    Step(
      title: const Text('Chinese Meaning'),
      content: Container(
        alignment: Alignment.centerLeft,
        child: const TextField(),
      ),
    ),
    Step(
      title: const Text('English Meaning'),
      content: Container(
        alignment: Alignment.centerLeft,
        child: const TextField(),
      ),
    ),
    Step(
      title: const Text('Conjugation'),
      content: Container(
        alignment: Alignment.centerLeft,
        child: const TextField(),
      ),
    ),
    Step(
      title: const Text('Explanation'),
      content: Container(
        alignment: Alignment.centerLeft,
        child: const TextField(),
      ),
    ),
    Step(
      title: const Text('Examples'),
      content: Container(
        alignment: Alignment.centerLeft,
        child: const Text('Content for Step 2'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _buildUI(context);
    final stepCount = _steps.length;

    return Stepper(
      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        } else {
          Navigator.of(context).pop();
        }
      },
      onStepContinue: () {
        if (_index < stepCount - 1) {
          setState(() {
            _index += 1;
          });
        } else {
          // Add the new grammar piece
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      steps: _steps,
    );
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
      final bloc = BlocProvider.of<GrammarBloc>(context);
      bloc.add(GrammarItemAdded(item: grammarItem));
    } else {
      // User canceled the picker
    }
  }

  _parseYamlString(String yamlString) {
    final yamlMap = loadYaml(yamlString);
    final pattern = yamlMap['pattern'];
    final level = yamlMap['level'];
    final meanings = yamlMap['meanings'];
    final conjugations = yamlMap['conjugations'];
    final explanation = yamlMap['explanation'];
    final examples = yamlMap['examples'];

    final grammar = GrammarItem(
      title: pattern,
      jpMeanings: [],
      cnMeanings: [],
      conjugations: conjugations.map<String>((e) => e.toString()).toList(),
      explanation: explanation ?? [],
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
