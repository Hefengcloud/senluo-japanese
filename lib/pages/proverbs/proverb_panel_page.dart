import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/pages/proverbs/widgets/proverb_card_widget.dart';
import 'package:senluo_japanese_cms/pages/proverbs/widgets/proverb_display_widget.dart';
import 'package:yaml/yaml.dart';

import '../../repos/proverbs/models/proverb_item.dart';
import 'bloc/proverb_bloc.dart';

class ProverbPanelPage extends StatefulWidget {
  const ProverbPanelPage({super.key});

  @override
  State<ProverbPanelPage> createState() => _ProverbPanelPageState();
}

class _ProverbPanelPageState extends State<ProverbPanelPage> {
  ProverbCategory? _category;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProverbBloc, ProverbState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Proverbs')),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filters'),
                _buildFilters(context),
                if (state is ProverbLoading) _buildLoading(context),
                if (state is ProverbLoaded) _buildProverbGrid(context, state),
              ],
            ),
          ),
          endDrawer: _buildDrawer(context),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _importFromYaml(context);
            },
            child: const Icon(Icons.file_open),
          ),
        );
      },
    );
  }

  _buildLoading(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  _buildDrawer(BuildContext context) {
    return Drawer();
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

  _buildProverbGrid(BuildContext context, ProverbLoaded state) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: state.items
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
      setState(() {});
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
