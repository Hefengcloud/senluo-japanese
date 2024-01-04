import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/pages/vocabulary/views/vocabulary_preview_view.dart';

import '../../../common/models/word.dart';
import '../../../constants/colors.dart';
import '../../kanji/constants/styles.dart';

class VocabularyGridView extends StatefulWidget {
  final List<Word> wordList;

  const VocabularyGridView({super.key, required this.wordList});

  @override
  State<VocabularyGridView> createState() => _VocabularyGridViewState();
}

class _VocabularyGridViewState extends State<VocabularyGridView> {
  static final _kGroupColors = [
    Colors.red[50],
    Colors.orange[50],
    Colors.yellow[50],
    Colors.green[50],
    Colors.cyan[50],
    Colors.blue[50],
    Colors.purple[50],
  ];
  List<String> _selectedGroupKeys = [];

  @override
  Widget build(BuildContext context) {
    final groupKeys =
        groupBy(widget.wordList, (word) => word.category).keys.toList();
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: _buildTopFilter(groupKeys.toList()),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 6,
                childAspectRatio: 2,
                children: _selectedGroupKeys.isNotEmpty
                    ? widget.wordList
                        .where((word) =>
                            _selectedGroupKeys.contains(word.category))
                        .map<Widget>((word) => _buildWordCard(
                              word,
                              _kGroupColors[groupKeys.indexOf(word.category)]!,
                            ))
                        .toList()
                    : widget.wordList
                        .map<Widget>((word) => _buildWordCard(
                              word,
                              _kGroupColors[groupKeys.indexOf(word.category)]!,
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
          child: VocabularyPreviewView(
            words: widget.wordList,
          ),
        ),
      ),
    );
  }
}
