import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/common/constants/themes.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';
import 'package:senluo_japanese_cms/pages/kanji/kanji_list_page.dart';

import 'bloc/kanji_bloc.dart';

class KanjiHomePage extends StatefulWidget {
  const KanjiHomePage({super.key});

  @override
  State<KanjiHomePage> createState() => _KanjiHomePageState();
}

class _KanjiHomePageState extends State<KanjiHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KanjiBloc, KanjiState>(
      builder: (context, state) {
        return _buildContent(context, state);
      },
      listener: (BuildContext context, KanjiState state) {
        if (state is KanjiLoaded && state.jlptLevel != JLPTLevel.none) {}
      },
    );
  }

  _buildContent(BuildContext context, KanjiState state) {
    var currentLevel = JLPTLevel.none;
    if (state is KanjiLoaded) {
      currentLevel = state.jlptLevel;
    }
    return SafeArea(
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                child: Text('JLPT 漢字'),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                KanjiNavigationView(
                  currentLevel: currentLevel,
                  onLevelChanged: (level) => _onLevelSelected(context, level),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _onLevelSelected(BuildContext context, JLPTLevel level) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RepositoryProvider.value(
          value: context.read<KanjiBloc>().kanjiRepository,
          child: KanjiListPage(level: level),
        ),
      ),
    );
  }
}

class KanjiNavigationView extends StatelessWidget {
  final Function(JLPTLevel level) onLevelChanged;
  final JLPTLevel currentLevel;

  const KanjiNavigationView({
    super.key,
    required this.currentLevel,
    required this.onLevelChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: JLPTLevel.values
          .where((e) => e != JLPTLevel.none)
          .toList()
          .map(
            (e) => ListTile(
              trailing: const Icon(Icons.arrow_right),
              // trailing: currentLevel == e ? const Icon(Icons.check) : null,
              title: Text(e.name.toUpperCase(), style: kHomeNavTextStyle),
              onTap: () => onLevelChanged(e),
            ),
          )
          .toList(),
    );
  }
}
