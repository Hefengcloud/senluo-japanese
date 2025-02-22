import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';
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
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(8),
      children: JLPTLevel.values
          .where((e) => e != JLPTLevel.none)
          .toList()
          .map(
            (e) => Card(
              child: InkWell(
                child: Center(
                  child: Text(
                    e.name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.kleeOne(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: kLevel2color[e],
                    ),
                  ),
                ),
                onTap: () => onLevelChanged(e),
              ),
            ),
          )
          .toList(),
    );
  }
}
