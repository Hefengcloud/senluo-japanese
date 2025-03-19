import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_common/senluo_common.dart';
import 'package:senluo_japanese_cms/common/enums/enums.dart';

import '../../repos/kanji/models/kanji_model.dart';
import 'bloc/kanji_bloc.dart';
import 'kanji_detail_page.dart';

class KanjiListPage extends StatelessWidget {
  final JLPTLevel level;

  const KanjiListPage({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    context.read<KanjiBloc>().add(KanjiLevelChanged(level));

    return BlocBuilder<KanjiBloc, KanjiState>(
      builder: (context, state) {
        final total = state is KanjiLoaded ? (state).kanjis.length : 0;
        return Scaffold(
          appBar: AppBar(
            title: Text("${level.name.toUpperCase()} ($total)"),
          ),
          body: state is KanjiLoaded && state.kanjis.isNotEmpty
              ? _GridView(kanjis: state.kanjis)
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class _GridView extends StatelessWidget {
  final List<Kanji> kanjis;
  const _GridView({required this.kanjis});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: kanjis
            .map<Widget>((kanji) => _buildKanjiCard(context, kanji))
            .toList(),
      ),
    );
  }

  _buildKanjiCard(BuildContext context, Kanji kanji) => Card(
        child: InkWell(
          child: Center(
            child: Text(
              kanji.char,
              style: GoogleFonts.kleeOne(
                fontSize: 48,
                color: kBrandColor,
              ),
            ),
          ),
          onTap: () => _showKanjiPreview(context, kanjis.indexOf(kanji)),
        ),
      );

  _showKanjiPreview(BuildContext context, int index) {
    context.read<KanjiBloc>().add(KanjiDetailStarted(index: index));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => KanjiDetailPage(index: index),
      ),
    );
  }
}
