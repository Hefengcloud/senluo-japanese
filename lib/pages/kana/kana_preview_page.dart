import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ruby_text/ruby_text.dart';
import 'package:senluo_japanese_cms/pages/kana/bloc/kana_bloc.dart';

import '../../repos/gojuon/kana_repository.dart';
import '../../repos/gojuon/models/models.dart';
import 'bloc/display/kana_display_bloc.dart';

class KanaPreviewPage extends StatefulWidget {
  static const kWordStyle = TextStyle(fontSize: 16);
  static const kOriginImageWidth = 48.0;

  final int initialIndex;
  final Kana kana;
  final KanaType type;
  final KanaCategory category;

  const KanaPreviewPage({
    super.key,
    required this.initialIndex,
    required this.kana,
    required this.type,
    required this.category,
  });

  @override
  State<KanaPreviewPage> createState() => _KanaPreviewPageState();
}

class _KanaPreviewPageState extends State<KanaPreviewPage> {
  late PageController _pageViewController;
  late int _currentPageIndex;

  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initTTS();
    _currentPageIndex = widget.initialIndex;
    _pageViewController = PageController(initialPage: _currentPageIndex);
  }

  void _initTTS() async {
    await _tts.setLanguage("ja-JP");
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<KanaDisplayBloc>(
      create: (context) => KanaDisplayBloc(context.read<KanaRepository>())
        ..add(KanaDisplayStarted(
          kana: widget.kana,
          type: widget.type,
          category: widget.category,
        )),
      child: BlocBuilder<KanaDisplayBloc, KanaDisplayState>(
        builder: (context, state) {
          return Scaffold(
            appBar: _buildAppBar(state),
            body: state is KanaDisplayLoaded
                ? _buildBody(context, state)
                : const Center(child: CircularProgressIndicator()),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showStrokeDialog(context),
              child: const FaIcon(FontAwesomeIcons.pen),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(KanaDisplayState state) {
    var title = "Loading";

    if (state is KanaDisplayLoaded) {
      final kana = state.isHiragana
          ? state.leadingKana.hiragana
          : state.leadingKana.katakana;
      title = "「$kana」行";
    }
    return AppBar(
      title: Text(title),
    );
  }

  Widget _buildBody(BuildContext context, KanaDisplayLoaded state) {
    return Stack(
      children: [
        _KanaPageIndicator(
          kanaRow: state.row,
          currentPageIndex: _currentPageIndex,
          onUpdateCurrentPageIndex: _updateCurrentPageIndex,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 56),
          child: PageView(
            controller: _pageViewController,
            onPageChanged: _handlePageViewChanged,
            children: state.row.map<Widget>((kana) {
              return _buildKanaPage(context, kana);
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _pageViewController.jumpToPage(index);
  }

  _showStrokeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("筆順"),
          content: Image.asset("assets/kana/strokes/h0a.gif"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("閉じる"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKanaPage(BuildContext context, Kana kana) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildKanaCard(context, kana),
            const Gap(8),
            const _Subtitle(text: "由来"),
            const Gap(8),
            _buildOrigins(context, kana),
            const Gap(8),
            const _Subtitle(text: "言葉"),
            const Gap(8),
            _buildRelatedWords(context, kana),
          ],
        ),
      ),
    );
  }

  _buildOrigins(BuildContext context, Kana kana) {
    String kanaKey = kana.romaji.split('/')[0];
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/kana/origins/${kanaKey}0.png",
                width: KanaPreviewPage.kOriginImageWidth,
              ),
              const Icon(Icons.arrow_right),
              Image.asset(
                "assets/kana/origins/${kanaKey}1.png",
                width: KanaPreviewPage.kOriginImageWidth,
              ),
              const Icon(Icons.arrow_right),
              Image.asset(
                "assets/kana/origins/${kanaKey}2.png",
                width: KanaPreviewPage.kOriginImageWidth,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildRelatedWords(BuildContext context, Kana kana) {
    final repo = context.read<KanaBloc>().kanaRepo;

    return FutureBuilder<List<String>>(
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text('なし');
        }
        final words = snapshot.data!;
        return SizedBox(
          width: double.infinity,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: words
                    .take(4)
                    .map(
                      (e) => InkWell(
                        onTap: () => _tts.speak(e),
                        child: RubyText(
                          _parseWordList(e),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      },
      future: repo.loadKanaWords(kana.hiragana),
    );
  }

  List<RubyTextData> _parseWordList(String word) {
    final rubyDataList = <RubyTextData>[];
    final line = word;
    // Remove the leading "- " if present
    final trimmedLine = line.replaceFirst(RegExp(r'^- '), '').trim();
    if (trimmedLine.isEmpty) return [];

    // Check if the line contains parentheses (indicating kanji and furigana)
    if (trimmedLine.contains('（') && trimmedLine.contains('）')) {
      final parts = trimmedLine.split('（');
      final furigana = parts[0].trim();
      final kanjiPart = parts[1].replaceAll('）', '').trim();

      // Handle cases with multiple kanji separated by " / "
      if (kanjiPart.contains(' / ')) {
        final kanjiOptions = kanjiPart.split(' / ');
        for (var i = 0; i < kanjiOptions.length; i++) {
          rubyDataList
              .add(RubyTextData(kanjiOptions[i].trim(), ruby: furigana));
          if (i < kanjiOptions.length - 1) {
            rubyDataList.add(const RubyTextData(' / '));
          }
        }
      } else {
        rubyDataList.add(RubyTextData(kanjiPart, ruby: furigana));
      }
    } else {
      // No parentheses, just plain text (hiragana or katakana)
      rubyDataList.add(RubyTextData(trimmedLine));
    }

    return rubyDataList;
  }

  _buildKanaCard(BuildContext context, Kana kana) {
    final state = context.read<KanaDisplayBloc>().state as KanaDisplayLoaded;

    return SizedBox(
      width: double.infinity,
      child: Card(
        child: InkWell(
          onTap: () async {
            final audioPath = 'kana/audios/${kana.key}.m4a';
            try {
              await _player.play(AssetSource(audioPath)); // For assets
            } catch (e) {
              print('Error playing audio: $e');
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AutoSizeText(
                state.type == KanaType.hiragana ? kana.hiragana : kana.katakana,
                style: GoogleFonts.kleeOne(
                  fontSize: 140,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              const FaIcon(FontAwesomeIcons.volumeHigh, size: 16),
              const Gap(4),
              Text(kana.romaji, style: const TextStyle(fontSize: 18)),
              const Gap(32),
            ],
          ),
        ),
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _KanaIndicator extends StatelessWidget {
  const _KanaIndicator({required this.text, this.isLarge = false});

  final String text;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: isLarge ? 40 : 32,
      height: isLarge ? 40 : 32,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(isLarge ? 20 : 16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: isLarge ? 20 : 16,
        ),
      ),
    );
  }
}

class _KanaPageIndicator extends StatelessWidget {
  const _KanaPageIndicator({
    required this.kanaRow,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
  });

  final int currentPageIndex;
  final KanaRow kanaRow;
  final void Function(int) onUpdateCurrentPageIndex;

  @override
  Widget build(BuildContext context) {
    final state = context.read<KanaDisplayBloc>().state as KanaDisplayLoaded;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              onUpdateCurrentPageIndex(0);
              context
                  .read<KanaDisplayBloc>()
                  .add(const KanaDisplayRowChanged(false));
            },
            icon: const Icon(Icons.arrow_left_rounded, size: 32.0),
          ),
          ...kanaRow.mapIndexed<Widget>(
            (index, kana) => GestureDetector(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _KanaIndicator(
                  isLarge: index == currentPageIndex,
                  text: state.type == KanaType.hiragana
                      ? kana.hiragana
                      : kana.katakana,
                ),
              ),
              onTap: () {
                onUpdateCurrentPageIndex(index);
              },
            ),
          ),
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              onUpdateCurrentPageIndex(0);
              context
                  .read<KanaDisplayBloc>()
                  .add(const KanaDisplayRowChanged(true));
            },
            icon: const Icon(Icons.arrow_right_rounded, size: 32.0),
          ),
        ],
      ),
    );
  }
}
