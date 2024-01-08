import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/common/constants/number_constants.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';
import 'package:senluo_japanese_cms/pages/kanji/views/kanji_grid_view.dart';
import 'package:senluo_japanese_cms/pages/kanji/views/kanji_navigation_view.dart';

import '../../repos/kanji/models/kanji_model.dart';
import 'bloc/kanji_bloc.dart';

class KanjiHomePage extends StatelessWidget {
  const KanjiHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KanjiBloc, KanjiState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('漢字')),
          body: _buildBody(context, state),
        );
      },
    );
  }

  _buildBody(BuildContext context, KanjiState state) {
    return Row(
      children: [
        SizedBox(
          width: kMenuPanelWidth,
          child: _buildLeftNavigation(context, state),
        ),
        if (state is KanjiLoaded)
          Expanded(
            child: _buildRightPanel(context, state.kanjis),
          ),
        if (state is KanjiLoading)
          const Expanded(
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  _buildLeftNavigation(BuildContext context, KanjiState state) {
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

  _buildRightPanel(BuildContext context, List<Kanji> kanjis) {
    return KanjiGridView(kanjis: kanjis);
  }
}
