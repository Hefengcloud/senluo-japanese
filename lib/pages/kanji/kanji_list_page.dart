import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/constants/colors.dart';
import '../../common/constants/constants.dart';
import '../../repos/kanji/models/kanji_model.dart';
import 'constants/styles.dart';
import 'kanji_preview_page.dart';

class KanjiListPage extends StatefulWidget {
  final List<Kanji> kanjis;

  const KanjiListPage({super.key, required this.kanjis});

  @override
  State<KanjiListPage> createState() => _KanjiListPageState();
}

class _KanjiListPageState extends State<KanjiListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanjis'),
      ),
      body: KanjiGridView(kanjis: widget.kanjis),
    );
  }
}

class KanjiGridView extends StatelessWidget {
  final List<Kanji> kanjis;
  const KanjiGridView({super.key, required this.kanjis});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 5,
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
              width: kPreviewDialogWidth,
              height: kPreviewDialogHeight,
              child: KanjiPreviewPage(kanji: kanji),
            ),
          );
        },
      );
}
