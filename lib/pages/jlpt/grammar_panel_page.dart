import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/pages/jlpt/bloc/grammar_bloc.dart';
import 'package:senluo_japanese_cms/pages/jlpt/widgets/grammar_detail_view.dart';
import 'package:senluo_japanese_cms/pages/jlpt/widgets/grammar_level_view.dart';
import 'package:senluo_japanese_cms/pages/jlpt/widgets/grammar_list_view.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

import 'widgets/grammar_adding_view.dart';

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
                  child: const GrammarDetailView(),
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
        GrammarListView(items: items),
        ElevatedButton(
          onPressed: () {
            _showAddDialog(context);
          },
          child: const Text('Add Grammar'),
        ),
      ],
    );
  }

  _buildSearchBox(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
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
            child: GrammarAddingView(),
          ),
        );
      },
    );
  }
}
