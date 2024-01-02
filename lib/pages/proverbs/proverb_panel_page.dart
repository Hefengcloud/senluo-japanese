import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/constants/kanas.dart';
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

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      final keyword = _searchController.text.trim();
      BlocProvider.of<ProverbBloc>(context)
          .add(ProverbSearched(keyword: keyword));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProverbBloc, ProverbState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: Row(
            children: [
              Expanded(flex: 1, child: _buildLeftPanel(context, state)),
              const VerticalDivider(width: 1),
              Expanded(flex: 3, child: _buildRightPanel(context, state)),
            ],
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

  _buildRightPanel(BuildContext context, ProverbState state) {
    if (state is ProverbLoading) {
      return _buildLoading(context);
    } else if (state is ProverbLoaded) {
      return _buildProverbGrid(context, state);
    }
  }

  _buildLeftPanel(BuildContext context, ProverbState state) {
    int? totalCount;
    var currentKanaLine = KanaLine.none;

    if (state is ProverbLoaded) {
      totalCount = state.items.length;
      currentKanaLine = state.currentKanaLine;
    }

    return ListView(
      children: [
        if (totalCount != null) ListTile(title: Text('Total: $totalCount')),
        const Divider(),
        ...KanaLine.values.map<ListTile>((line) {
          return ListTile(
            trailing: line == currentKanaLine ? const Icon(Icons.check) : null,
            title: Text("${line != KanaLine.none ? line.name : '全部'} 行"),
            onTap: () {
              BlocProvider.of<ProverbBloc>(context)
                  .add(ProverbFiltered(kanaLine: line));
            },
          );
        }).toList(),
      ],
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      leading: const Icon(
        Icons.search,
        color: Colors.white,
      ),
      title: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: const InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.white54),
          border: InputBorder.none,
        ),
      ),
    );
  }

  _buildLoading(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  _buildDrawer(BuildContext context) {
    return Drawer();
  }

  _buildFilters(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
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
    return GridView.count(
      crossAxisCount: 6,
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
