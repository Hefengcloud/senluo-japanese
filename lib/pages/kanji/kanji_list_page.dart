import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/common/enums/enums.dart';
import 'package:senluo_japanese_cms/repos/kanji/kanji_repository.dart';

import '../../common/constants/colors.dart';
import '../../repos/kanji/models/kanji_model.dart';
import 'kanji_preview_page.dart';

class KanjiListPage extends StatefulWidget {
  final JLPTLevel level;

  const KanjiListPage({super.key, required this.level});

  @override
  State<KanjiListPage> createState() => _KanjiListPageState();
}

class _KanjiListPageState extends State<KanjiListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.level.name.toUpperCase()),
      ),
      body: FutureBuilder<List<Kanji>>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _GridView(kanjis: snapshot.data!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
        future: context.read<KanjiRepository>().loadJlptKanjis(widget.level),
      ),
    );
  }
}

class _GridView extends StatelessWidget {
  final List<Kanji> kanjis;
  const _GridView({required this.kanjis});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
          onTap: () => _showKanjiPreview(context, kanji),
        ),
      );

  _showKanjiPreview(BuildContext context, Kanji kanji) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => KanjiPreviewPage(kanji: kanji),
      ),
    );
  }
}
