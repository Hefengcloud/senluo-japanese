import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';
import 'package:senluo_japanese_cms/pages/kanji/kanji_list_page.dart';

import '../../common/constants/colors.dart';
import 'bloc/kanji_bloc.dart';

class KanjiHomePage extends StatefulWidget {
  const KanjiHomePage({super.key});

  @override
  State<KanjiHomePage> createState() => _KanjiHomePageState();
}

class _KanjiHomePageState extends State<KanjiHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KanjiBloc, KanjiState>(
      builder: (context, state) {
        return _buildNavigation(context, state);
      },
      listener: (BuildContext context, KanjiState state) {
        if (state is KanjiLoaded && state.jlptLevel != JLPTLevel.none) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => KanjiListPage(kanjis: state.kanjis),
            ),
          );
        }
      },
    );
  }

  _buildNavigation(BuildContext context, KanjiState state) {
    var currentLevel = JLPTLevel.none;
    if (state is KanjiLoaded) {
      currentLevel = state.jlptLevel;
    }
    return KanjiNavigationView(
      currentLevel: currentLevel,
      onLevelChanged: (level) =>
          BlocProvider.of<KanjiBloc>(context).add(KanjiLevelChanged(level)),
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
      children: [
        const ListTile(
          title: Text(
            'JLPT',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: kBrandColor,
            ),
          ),
        ),
        ...JLPTLevel.values.where((e) => e != JLPTLevel.none).toList().map(
              (e) => ListTile(
                leading: const Icon(Icons.arrow_right),
                trailing: currentLevel == e ? const Icon(Icons.check) : null,
                title: Text(e.name.toUpperCase()),
                onTap: () => onLevelChanged(e),
              ),
            ),
      ],
    );
  }
}
