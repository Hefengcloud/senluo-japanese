import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/pages/grammars/grammar_details_page.dart';
import 'package:senluo_japanese_cms/pages/grammars/views/grammar_menu_list_view.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

import '../../common/enums/enums.dart';
import '../../repos/grammars/models/grammar_entry.dart';
import 'bloc/grammar_bloc.dart';

class GrammarHomePage extends StatefulWidget {
  const GrammarHomePage({super.key});

  @override
  State<GrammarHomePage> createState() => _GrammarHomePageState();
}

class _GrammarHomePageState extends State<GrammarHomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 1, vsync: this);
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
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GrammarBloc, GrammarState>(
      builder: (context, state) {
        return _buildBody(context, state);
      },
      listener: (BuildContext context, GrammarState state) {
        if (state is GrammarLoaded && state.currentItem != GrammarItem.empty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RepositoryProvider(
                create: (BuildContext context) =>
                    BlocProvider.of<GrammarBloc>(context).grammarRepository,
                child: GrammarDetailsPage(item: state.currentItem),
              ),
            ),
          );
        }
      },
    );
  }

  _buildBody(BuildContext context, GrammarState state) {
    return switch (state) {
      GrammarLoading() => const Center(child: CircularProgressIndicator()),
      GrammarError() => const Text('Something went wrong!'),
      GrammarLoaded() => _buildContent(context, state.entryMap)
    };
  }

  _buildContent(context, Map<JLPTLevel, List<GrammarEntry>> entryMap) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'JLPT文法'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              GrammarMenuListView(
                onEntrySelected: (entry) =>
                    BlocProvider.of<GrammarBloc>(context)
                        .add(GrammarEntryChanged(entry: entry)),
                grammarsByLevel: entryMap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
