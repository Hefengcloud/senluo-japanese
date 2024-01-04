import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/models/word.dart';
import '../../onomatopoeia/constants/colors.dart';

class VocabularyPreviewView extends StatefulWidget {
  final List<Word> words;

  const VocabularyPreviewView({super.key, required this.words});

  @override
  State<VocabularyPreviewView> createState() => _VocabularyPreviewViewState();
}

class _VocabularyPreviewViewState extends State<VocabularyPreviewView> {
  static const _kPageWordCount = 9;

  int? _pageIndex;
  int _groupKeyIndex = 0;

  @override
  Widget build(BuildContext context) {
    final groups = groupBy(widget.words, (word) => word.category);
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: _buildImage(groups),
          ),
        ),
        Expanded(
          flex: 2,
          child: _buildPanel(groups),
        )
      ],
    );
  }

  _buildImage(Map<String, List<Word>> groups) => Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(color: kItemBgColor),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Gap(18),
            Text(
              '日语背单词',
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(
                'ZCOOL KuaiLe',
                fontSize: 48,
                color: kItemMainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            Text(
              '金钱、费用',
              style: GoogleFonts.getFont(
                'ZCOOL KuaiLe',
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(18),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: widget.words
                    .take(_kPageWordCount)
                    .map<Widget>(
                      (word) => _buildWordCard(word),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      );

  _buildWordCard(Word word) => Card(
        color: Colors.white,
        shadowColor: Colors.transparent,
        child: Column(
          children: [
            const Gap(24),
            AutoSizeText(
              word.text,
              style: GoogleFonts.getFont(
                'Yusei Magic',
                fontSize: 20,
                color: kItemMainColor,
              ),
            ),
            Text(
              word.reading,
              style: GoogleFonts.getFont(
                'Yusei Magic',
                color: Colors.black45,
              ),
            ),
            const Spacer(),
            Text(
              word.meaning.en,
              textAlign: TextAlign.center,
            ),
            const Gap(24),
          ],
        ),
      );

  _buildPanel(Map<String, List<Word>> groups) {
    return Stack(
      children: [
        DefaultTabController(
          length: groups.keys.length,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TabBar(
                tabs: groups.keys.map((e) => Tab(text: e)).toList(),
              ),
              Expanded(
                child: TabBarView(
                  children: groups.keys
                      .map<Widget>((key) => _buildWordListView(groups[key]!))
                      .toList(),
                ),
              ),
              const Gap(80),
            ],
          ),
        ),
        Positioned.fill(
          left: 16,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPageChoices(),
                const Gap(16),
                ElevatedButton(
                  child: Text('Save Image'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildWordListView(List<Word> words) => ListView(
        children: words.map((e) => ListTile(title: Text(e.text))).toList(),
      );

  _buildPageChoices() {
    int wordCount = widget.words.length;
    int pageCount = wordCount ~/ _kPageWordCount;
    if (wordCount % _kPageWordCount > 0) {
      pageCount++;
    }
    return Wrap(
      spacing: 5.0,
      children: List<Widget>.generate(
        pageCount,
        (int index) {
          return ChoiceChip(
            label: Text('${index + 1}'),
            side: BorderSide.none,
            selected: _pageIndex == index,
            onSelected: (bool selected) {
              setState(() {
                _pageIndex = selected ? index : 0;
              });
            },
          );
        },
      ).toList(),
    );
  }
}
