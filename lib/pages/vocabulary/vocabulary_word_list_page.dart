import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/models/word.dart';
import '../../common/constants/colors.dart';
import '../kanji/constants/styles.dart';

class VocabularyWordListPage extends StatefulWidget {
  final String title;
  final List<Word> wordList;

  const VocabularyWordListPage({
    super.key,
    required this.title,
    required this.wordList,
  });

  @override
  State<VocabularyWordListPage> createState() => _VocabularyWordListPageState();
}

class _VocabularyWordListPageState extends State<VocabularyWordListPage> {
  late List<String> _groupKeys;

  @override
  Widget build(BuildContext context) {
    _groupKeys =
        groupBy(widget.wordList, (word) => word.category).keys.toList();
    return _buildContent();
  }

  _buildContent() {
    return DefaultTabController(
      length: _groupKeys.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            tabs: _groupKeys.map((key) => Tab(text: key)).toList(),
          ),
        ),
        body: TabBarView(
          children: _groupKeys
              .map(
                (key) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildGroupContent(key),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildGroupContent(String key) {
    final words =
        widget.wordList.where((word) => word.category == key).toList();

    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(
            words[index].text,
            style: GoogleFonts.getFont(
              kKanjiFontName,
              fontSize: 16,
              color: kBrandColor,
            ),
          ),
          subtitle: Text(words[index].meaning.en),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemCount: words.length,
    );
  }
}
