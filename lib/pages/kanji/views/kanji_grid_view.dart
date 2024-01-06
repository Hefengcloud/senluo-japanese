import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/kanji/constants/styles.dart';
import 'package:senluo_japanese_cms/pages/kanji/kanji_preview_page.dart';

import '../../../repos/kanji/models/kanji_model.dart';

class KanjiGridView extends StatelessWidget {
  final List<Kanji> kanjis;
  const KanjiGridView({super.key, required this.kanjis});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 8,
      children: kanjis
          .map<Widget>((kanji) => _buildKanjiCard(context, kanji))
          .toList(),
    );
  }

  _buildKanjiCard(BuildContext context, Kanji kanji) => Card(
        child: InkWell(
          child: Center(
            child: Text(
              kanji.char,
              style: GoogleFonts.getFont(
                kKanjiFontName,
                fontSize: 48,
                color: kBrandColor,
              ),
            ),
          ),
          onTap: () => _showKanjiPreview(context, kanji),
        ),
      );

  _showKanjiPreview(BuildContext context, Kanji kanji) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              child: KanjiPreviewPage(kanji: kanji),
              width: 675,
              height: 600,
            ),
          );
        },
      );
}
