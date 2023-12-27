import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/onomatopoeia_card.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';

class OnomatopoeiaPage extends StatefulWidget {
  const OnomatopoeiaPage({super.key});

  @override
  State<OnomatopoeiaPage> createState() => _OnomatopoeiaPageState();
}

class _OnomatopoeiaPageState extends State<OnomatopoeiaPage> {
  final _collections = [
    'all',
    'body',
    'clothes',
    'feeling',
    'food',
    'sense',
    'shape',
    'sound',
    'state',
    'temperature',
    'voice',
    'water',
    'weather',
  ];

  Onomatopoeia? onomatopoeia;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('オノマトペ')),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: _buildLeftPanel(context)),
        const VerticalDivider(width: 1.0),
        Expanded(flex: 3, child: _buildRightPanel(context)),
      ],
    );
  }

  _buildLeftPanel(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          itemBuilder: (context, index) => ListTile(
            title: Text(_collections[index]),
            onTap: () {},
          ),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: _collections.length,
        ),
        Positioned.fill(
          bottom: 32,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () => _pickYamlFile(),
              label: const Text('Add New Item'),
            ),
          ),
        ),
      ],
    );
  }

  _buildRightPanel(BuildContext context) {
    if (onomatopoeia != null) {
      return OnomatopoeiaCard(item: onomatopoeia!);
    } else {
      return Text('empty');
    }
  }

  _pickYamlFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['yaml', 'yml'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      final yamlString = await file.readAsString();
      final item = Onomatopoeia.fromYamlString(yamlString);
      setState(() {
        onomatopoeia = item;
      });
    } else {
      // User canceled the picker
    }
  }
}
