import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/common/constants/number_constants.dart';
import 'package:senluo_japanese_cms/pages/grammars/bloc/grammar_item_bloc.dart';
import 'package:senluo_japanese_cms/pages/grammars/grammar_preview_page.dart';
import 'package:senluo_japanese_cms/pages/grammars/views/grammar_menu_list_view.dart';
import 'package:senluo_japanese_cms/pages/grammars/views/grammar_entry_grid_view.dart';
import 'package:senluo_japanese_cms/repos/grammars/grammar_repository.dart';

import '../../repos/grammars/models/grammar_entry.dart';
import 'bloc/grammar_bloc.dart';

class GrammarHomePage extends StatefulWidget {
  const GrammarHomePage({super.key});

  @override
  State<GrammarHomePage> createState() => _GrammarHomePageState();
}

class _GrammarHomePageState extends State<GrammarHomePage> {
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
            SizedBox(
              width: kMenuPanelWidth,
              child: GrammarMenuListView(
                selectedLevel: state.currentLevel,
                onLevelSelected: (level) =>
                    BlocProvider.of<GrammarBloc>(context)
                        .add(GrammarLevelChanged(level: level)),
                level2Count: {
                  for (var entry in state.entryMap.entries)
                    entry.key: entry.value.length
                },
              ),
            ),
            Expanded(
              child: GrammarEntryGridView(
                entries: state.entries,
                onItemClicked: (GrammarEntry entry) =>
                    _showPreviewDialog(context, entry),
              ),
            ),
          ],
        ),
    };
  }

  _showPreviewDialog(BuildContext context, GrammarEntry entry) {
    final repo = BlocProvider.of<GrammarBloc>(context).grammarRepository;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: BlocProvider(
          create: (context) =>
              GrammarItemBloc(repo)..add(GrammarItemStarted(entry: entry)),
          child: SizedBox(
            width: 1000,
            height: 800,
            child: GrammarPreviewPage(),
          ),
        ),
      ),
    );
  }
}
