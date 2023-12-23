import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/proverbs/widgets/proverb_card_widget.dart';
import 'package:senluo_japanese_cms/pages/proverbs/widgets/proverb_display_widget.dart';
import 'package:yaml/yaml.dart';

import '../../repos/proverbs/models/proverb_item.dart';

class ProverbPanelPage extends StatefulWidget {
  const ProverbPanelPage({super.key});

  @override
  State<ProverbPanelPage> createState() => _ProverbPanelPageState();
}

class _ProverbPanelPageState extends State<ProverbPanelPage> {
  ProverbCategory? _category;

  List<ProverbItem> _items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proverbs')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filters'),
            _buildFilters(context),
            _buildProverbGrid(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _importFromYaml(context);
        },
        child: const Icon(Icons.file_open),
      ),
    );
  }

  _buildFilters(BuildContext context) {
    return Wrap(
      spacing: 5.0,
      children: ProverbCategory.values
          .map(
            (category) => ChoiceChip(
              label: Text(category.name),
              selected: _category == category,
              onSelected: (selected) {
                setState(() {
                  _category = selected ? category : null;
                });
              },
            ),
          )
          .toList(),
    );
  }

  _buildProverbGrid(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: _items
          .map<Widget>(
            (item) => InkWell(
              onTap: () => _showProverbCard(context, item),
              child: ProverbCardWidget(
                item: item,
              ),
            ),
          )
          .toList(),
    );
  }

  _importFromYaml(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['yaml', 'yml'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      final yamlString = await file.readAsString();
      final yamlMaps = loadYaml(yamlString);
      final items = yamlMaps
          .map<ProverbItem>(
            (map) => ProverbItem(
              name: map['item'],
              reading: map['yomi'],
              meanings: map['zh'].map<String>((e) => e.toString()).toList(),
              examples: map['examples']
                      ?.map<ProverbExample>((e) => ProverbExample(
                            jp: e['jp'],
                            zh: e['zh'],
                          ))
                      .toList() ??
                  [],
            ),
          )
          .toList();
      setState(() {
        _items = items;
      });
    }
  }

  _showProverbCard(BuildContext context, ProverbItem item) {
    Scaffold.of(context).openEndDrawer();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: 1000,
          child: ProverbDisplayWidget(
            item: item,
          ),
        ),
      ),
    );
  }
}

enum ProverbCategory {
  digit,
  animal,
  body,
}
