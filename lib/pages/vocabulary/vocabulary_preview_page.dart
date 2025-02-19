import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ruby_text/ruby_text.dart';

import '../../common/models/word.dart';
import '../../common/helpers/image_helper.dart';
import '../onomatopoeia/constants/colors.dart';
import 'bloc/preview_bloc.dart';

class VocabularyPreviewPage extends StatefulWidget {
  static const kWordCountPerPage = 9;

  const VocabularyPreviewPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.words,
  });

  final String title;
  final String subtitle;
  final List<Word> words;

  @override
  State<VocabularyPreviewPage> createState() => _VocabularyPreviewPageState();
}

class _VocabularyPreviewPageState extends State<VocabularyPreviewPage> {
  final GlobalKey _globalKey = GlobalKey();

  var _fontScale = 1.0;
  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.5;
  bool isPlaying = false;

  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTTS();
  }

  Future<void> _initTTS() async {
    // Set language to Japanese
    await flutterTts.setLanguage("ja-JP");

    // Initialize other settings
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(rate);

    // Set completed handler
    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PreviewBloc>(
      create: (context) =>
          PreviewBloc()..add(PreviewStarted(words: widget.words)),
      child: BlocBuilder<PreviewBloc, PreviewState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('単語'),
            ),
            body: state is PreviewLoaded
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      RepaintBoundary(
                        key: _globalKey,
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: _buildImage(context, state),
                        ),
                      ),
                      // Positioned(
                      //   child: _buildPageChoices(context, state),
                      //   left: 0,
                      //   right: 0,
                      //   bottom: 0,
                      // ),
                    ],
                  )
                : const Center(child: LinearProgressIndicator()),
            bottomNavigationBar: _buildBottomAppBar(context),
          );
        },
      ),
    );
  }

  _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          Text('Font'),
          Slider(
              value: _fontScale,
              min: 0.8,
              max: 2.0,
              onChanged: (value) {
                setState(() {
                  _fontScale = value;
                });
              }),
          Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.save))
        ],
      ),
    );
  }

  _buildPageChoices(BuildContext context, PreviewLoaded state) {
    return Wrap(
      spacing: 5.0,
      children: List<Widget>.generate(
        state.pageCount,
        (int index) {
          return ChoiceChip(
            label: Text('${index + 1}'),
            side: BorderSide.none,
            selected: state.currentPage == index,
            onSelected: (bool selected) {
              BlocProvider.of<PreviewBloc>(context)
                  .add(PreviewPageChanged(page: selected ? index : 0));
            },
          );
        },
      ).toList(),
    );
  }

  _buildImage(BuildContext context, PreviewLoaded state) => Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(color: kItemBgColor),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Gap(8),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSansJp(
                color: kItemMainColor,
                fontSize: 24 * _fontScale,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            Text(
              widget.subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSansJp(
                fontSize: 24 * _fontScale,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: state.displayedWords
                    .map<Widget>((word) => _buildWordCard(word))
                    .toList(),
              ),
            ),
          ],
        ),
      );

  _buildWordCard(Word word) => Card(
        color: Colors.white,
        shadowColor: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await flutterTts.setLanguage("ja-JP");
            await flutterTts.speak(word.text);
            await Future.delayed(Duration(seconds: 1));
            await flutterTts.setLanguage("en");
            await flutterTts.speak(word.meaning.en);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                RubyText([
                  RubyTextData(
                    word.text,
                    ruby: word.reading,
                    style: GoogleFonts.notoSansJp(
                      fontSize: 20 * _fontScale,
                      fontWeight: FontWeight.bold,
                      color: kItemMainColor,
                    ),
                    rubyStyle: GoogleFonts.notoSansJp(
                      color: Colors.black45,
                    ),
                  ),
                ]),
                const Spacer(),
                Text(
                  word.meaning.en,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );

  _onSaveImage(String fileName) async {
    final bytes = await captureWidget(_globalKey);
    saveImageToFile(bytes!, '$fileName.jpg');
  }
}
