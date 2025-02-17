import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ruby_text/ruby_text.dart';
import 'package:senluo_japanese_cms/common/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/kanji/bloc/kanji_bloc.dart';

import '../../common/models/word.dart';
import '../../common/helpers/image_helper.dart';
import '../../common/helpers/text_helper.dart';
import '../../repos/kanji/models/kanji_model.dart';

class KanjiPreviewPage extends StatefulWidget {
  final Kanji kanji;

  const KanjiPreviewPage({super.key, required this.kanji});

  @override
  State<KanjiPreviewPage> createState() => _KanjiPreviewPageState();
}

class _KanjiPreviewPageState extends State<KanjiPreviewPage> {
  final _grayTitleStyle = const TextStyle(
    color: Colors.grey,
  );

  final GlobalKey globalKey = GlobalKey();

  double _fontScale = 1.0;

  @override
  Widget build(BuildContext context) {
    context.read<KanjiBloc>().add(KanjiDetailStarted(kanji: widget.kanji));

    return BlocBuilder<KanjiBloc, KanjiState>(
      builder: (context, state) {
        if (state is KanjiLoaded &&
            state.currentKanjiDetail != KanjiDetail.empty) {
          return _buildKanjiDetail(context, state.currentKanjiDetail);
        } else {
          return _buildLoading(context);
        }
      },
    );
  }

  _buildLoading(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('漢字'),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  _buildKanjiDetail(BuildContext context, KanjiDetail kanji) {
    return Scaffold(
      appBar: AppBar(title: const Text('漢字')),
      body: _buildBody(context, kanji),
      endDrawer: _buildDrawer(context, kanji),
      bottomNavigationBar: BottomAppBar(child: _buildBottomActions(kanji)),
    );
  }

  _buildBody(BuildContext context, KanjiDetail detail) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RepaintBoundary(
            key: globalKey,
            child: _buildImagePanel(context, detail),
          ),
        ),
        const Spacer(),
        _buildPageNavigators(context),
        const Spacer(),
      ],
    );
  }

  _buildPageNavigators(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 32,
          onPressed: () {
            context
                .read<KanjiBloc>()
                .add(const KanjiDetailChanged(previous: true));
          },
          icon: const Icon(Icons.arrow_left),
        ),
        const Gap(16),
        IconButton(
          iconSize: 32,
          onPressed: () {
            context
                .read<KanjiBloc>()
                .add(const KanjiDetailChanged(previous: false));
          },
          icon: const Icon(Icons.arrow_right),
        ),
      ],
    );
  }

  _buildBottomActions(Kanji kanji) => Row(
        children: [
          const Text('Scale:'),
          Expanded(
            child: Slider(
              value: _fontScale,
              min: 1,
              max: 1.5,
              onChanged: (value) {
                setState(() {
                  _fontScale = value;
                });
              },
            ),
          ),
          Text(_fontScale.toStringAsFixed(2)),
          IconButton(
            onPressed: () => _saveKanjiAsImage(kanji.key),
            icon: const Icon(Icons.save_outlined),
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
      style: GoogleFonts.kleeOne(
        fontSize: 128,
        color: kBrandColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  _buildMeaning(KanjiDetail detail) {
    return Row(
      children: [
        Text('意味', style: _grayTitleStyle.copyWith(fontSize: 14 * _fontScale)),
        const Gap(16),
        Text(
          detail.meaning,
          style: TextStyle(fontSize: 14 * _fontScale),
        ),
      ],
    );
  }

  _buildVocabulary(String title, List<String> words) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title  ',
          style: _grayTitleStyle.copyWith(fontSize: 14 * _fontScale),
        ),
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
          }).toList(),
        ),
      ],
    );
  }

  _buildWordMeaningText(Word word) => Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 4),
        child: word.reading.isNotEmpty
            ? RubyText(
                [RubyTextData(word.text, ruby: word.reading)],
                style: TextStyle(fontSize: 14 * _fontScale),
                textAlign: TextAlign.left,
                softWrap: true,
              )
            : Text(
                word.text,
                style: TextStyle(fontSize: 14 * _fontScale),
              ),
      );

  _buildReadingText(String title, List<String> readings) => Row(
        children: [
          Text(
            title,
            style: _grayTitleStyle.copyWith(fontSize: 14 * _fontScale),
          ),
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
                    child: Text(
                      e,
                      style: TextStyle(fontSize: 14 * _fontScale),
                    ),
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

  _buildDrawer(BuildContext context, KanjiDetail detail) {
    return Drawer(
      child: ListView(
        children: [
          const ListTile(title: Text('語彙リスト')),
          ...detail.words.map((e) {
            final word = parseMeaning(e);
            return ListTile(
              leading: const Text('言葉'),
              title: Text("${word.text}（${word.reading}）"),
              subtitle:
                  word.meaning.en.isNotEmpty ? Text(word.meaning.en) : null,
              onTap: () {},
            );
          }),
          ...detail.proverbs.map((e) {
            return ListTile(
              leading: const Text('こと\nわざ'),
              title: Text(e),
              onTap: () {},
            );
          }),
          ...detail.idioms.map((e) => ListTile(
                leading: const Text('四字\n熟語'),
                title: Text(e),
                onTap: () {},
              )),
        ],
      ),
    );
  }
}
