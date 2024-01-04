import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ruby_text/ruby_text.dart';
import 'package:senluo_japanese_cms/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/kanji/bloc/kanji_bloc.dart';
import 'package:senluo_japanese_cms/pages/kanji/constants/styles.dart';

import '../../common/models/word.dart';
import '../../helpers/image_helper.dart';
import '../../helpers/text_helper.dart';
import '../../repos/kanji/models/kanji_model.dart';

class KanjiPreviewPage extends StatelessWidget {
  final Kanji kanji;

  final _grayTitleStyle = const TextStyle(
    color: Colors.grey,
  );

  final GlobalKey globalKey = GlobalKey();

  KanjiPreviewPage({super.key, required this.kanji});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<KanjiBloc>(context);
    final repo = bloc.kanjiRepository;

    return FutureBuilder<KanjiDetail>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: [
              Expanded(
                flex: 1,
                child: RepaintBoundary(
                  key: globalKey,
                  child: _buildImagePanel(context, snapshot.data!),
                ),
              ),
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: _buildTextPanel(context, snapshot.data!),
                    ),
                    Positioned.fill(
                      left: 16,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: _buildBottomActions(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
      future: repo.loadKanjiDetail(kanji),
    );
  }

  _buildBottomActions() => Row(
        children: [
          ElevatedButton(
            onPressed: () => _saveKanjiAsImage(kanji.key),
            child: const Text('Save Image'),
          ),
        ],
      );

  _buildImagePanel(BuildContext context, KanjiDetail detail) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        decoration: BoxDecoration(
          color: kBgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildKanji(detail),
                const Gap(32),
                _buildReadings(detail),
              ],
            ),
            const Gap(32),
            _buildMeaning(detail),
            const Gap(32),
            _buildVocabulary('言葉', detail.words.take(8).toList()),
            if (detail.idioms.isNotEmpty) ...[
              const Gap(16),
              _buildVocabulary('四字熟語', detail.idioms.take(4).toList())
            ],
            if (detail.proverbs.isNotEmpty) ...[
              const Gap(16),
              _buildVocabulary('ことわざ', detail.proverbs.take(4).toList())
            ],
          ],
        ),
      ),
    );
  }

  _buildTextPanel(BuildContext context, KanjiDetail detail) {
    return ListView(
      children: [
        ...detail.words.map((e) {
          final word = parseMeaning(e);
          return ListTile(
            leading: const Text('言葉'),
            title: Text("${word.text}（${word.reading}）"),
            subtitle: word.meaning.en.isNotEmpty ? Text(word.meaning.en) : null,
            onTap: () {},
          );
        }).toList(),
        ...detail.proverbs.map((e) {
          return ListTile(
            leading: const Text('こと\nわざ'),
            title: Text(e),
            onTap: () {},
          );
        }).toList(),
        ...detail.idioms
            .map((e) => ListTile(
                  leading: const Text('四字\n熟語'),
                  title: Text(e),
                  onTap: () {},
                ))
            .toList(),
      ],
    );
  }

  Column _buildKanji(KanjiDetail detail) {
    return Column(
      children: [
        _buildKanjiCard(detail),
        Text("（${detail.strokeCount}）"),
      ],
    );
  }

  Column _buildReadings(KanjiDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReadingText('訓読み  ', detail.kunyomis),
        const Gap(8),
        _buildReadingText('音読み  ', detail.onyomis),
      ],
    );
  }

  Text _buildKanjiCard(KanjiDetail detail) {
    return Text(
      detail.char,
      style: GoogleFonts.getFont(
        kKanjiFontName,
        fontSize: 128,
        color: kBrandColor,
      ),
    );
  }

  _buildMeaning(KanjiDetail detail) {
    return Row(
      children: [
        Text('意味', style: _grayTitleStyle),
        const Gap(16),
        Text(detail.meaning),
      ],
    );
  }

  _buildVocabulary(String title, List<String> words) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title  ', style: _grayTitleStyle),
        const Gap(8),
        Wrap(
            children: words.map<Widget>((e) {
          final word = parseMeaning(e);
          return word.meaning.en.isNotEmpty
              ? Tooltip(
                  preferBelow: false,
                  message: word.meaning.en,
                  child: _buildWordMeaningText(word),
                )
              : _buildWordMeaningText(word);
        }).toList()),
      ],
    );
  }

  _buildWordMeaningText(Word word) => Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 4),
        child: word.reading.isNotEmpty
            ? RubyText(
                [RubyTextData(word.text, ruby: word.reading)],
                textAlign: TextAlign.left,
                softWrap: true,
              )
            : Text(
                word.text,
              ),
      );

  _buildReadingText(String title, List<String> readings) => Row(
        children: [
          Text(title, style: _grayTitleStyle),
          const Gap(16),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: readings
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                      bottom: 4,
                      top: 4,
                    ),
                    child: Text(e),
                  ),
                )
                .toList(),
          ),
        ],
      );

  _saveKanjiAsImage(String name) async {
    final bytes = await captureWidget(globalKey);
    await saveImageToFile(bytes!, '$name.png');
  }
}
