import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/pages/vocabulary/bloc/preview_bloc.dart';
import 'package:senluo_japanese_cms/pages/vocabulary/views/vocabulary_preview_view.dart';

import '../../common/models/word.dart';
import '../../common/constants/colors.dart';
import '../kanji/constants/styles.dart';

class VocabularyWordListPage extends StatefulWidget {
  final List<Word> wordList;

  const VocabularyWordListPage({super.key, required this.wordList});

  @override
  State<VocabularyWordListPage> createState() => _VocabularyWordListPageState();
}

class _VocabularyWordListPageState extends State<VocabularyWordListPage> {
  static final _kGroupColors = [
    Colors.red[50],
    Colors.orange[50],
    Colors.yellow[50],
    Colors.green[50],
    Colors.cyan[50],
    Colors.blue[50],
    Colors.purple[50],
    Colors.brown[50],
  ];
  List<String> _selectedGroupKeys = [];

  @override
  Widget build(BuildContext context) {
    final groupKeys =
        groupBy(widget.wordList, (word) => word.category).keys.toList();
    return _buildContent(groupKeys);
  }

  _buildContent(List<String> groupKeys) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Words'),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopFilter(groupKeys.toList()),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  children: _selectedGroupKeys.isNotEmpty
                      ? widget.wordList
                          .where((word) =>
                              _selectedGroupKeys.contains(word.category))
                          .map<Widget>((word) => _buildWordCard(
                                word,
                                _kGroupColors[
                                    groupKeys.indexOf(word.category)]!,
                              ))
                          .toList()
                      : widget.wordList
                          .map<Widget>((word) => _buildWordCard(
                                word,
                                _kGroupColors[
                                    groupKeys.indexOf(word.category)]!,
                              ))
                          .toList(),
                ),
              ),
            ],
          ),
          Positioned.fill(
            bottom: 32,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _buildBottomActions(),
            ),
          ),
        ],
      ),
    );
  }

  _buildTopFilter(List<String> groupKeys) {
    return Wrap(
      spacing: 8,
      children: groupKeys.mapIndexed((index, key) {
        return ChoiceChip(
          label: Text(key),
          selectedColor: _kGroupColors[index],
          backgroundColor: _kGroupColors[index],
          side: BorderSide.none,
          selected: _selectedGroupKeys.contains(key),
          onSelected: (selected) {
            final selectedKeys = List<String>.from(_selectedGroupKeys);
            if (selected) {
              selectedKeys.add(key);
            } else {
              selectedKeys.remove(key);
            }

            setState(() {
              _selectedGroupKeys = selectedKeys;
            });
          },
        );
      }).toList(),
    );
  }

  _buildWordCard(Word word, Color color) => Card(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(word.category),
            AutoSizeText(
              word.text,
              style: GoogleFonts.getFont(
                kKanjiFontName,
                fontSize: 20,
                color: kBrandColor,
              ),
            ),
            Text(word.reading),
          ],
        ),
      );

  _buildBottomActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            _showPreviewDialog(context);
          },
          child: const Text('Generate Image'),
        )
      ],
    );
  }

  _showPreviewDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: 800,
          height: 640,
          child: BlocProvider(
            create: (context) =>
                PreviewBloc()..add(PreviewStarted(words: widget.wordList)),
            child: VocabularyPreviewView(),
          ),
        ),
      ),
    );
  }
}
