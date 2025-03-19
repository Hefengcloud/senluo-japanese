import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_common/senluo_common.dart';
import 'package:senluo_japanese_cms/pages/vocabulary/vocabulary_preview_page.dart';

import '../../common/models/word.dart';

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
  late String _selectedGroupKey;

  @override
  Widget build(BuildContext context) {
    _groupKeys =
        groupBy(widget.wordList, (word) => word.category).keys.toList();
    _selectedGroupKey = _groupKeys.first;
    return _buildContent();
  }

  _buildContent() {
    return DefaultTabController(
      length: _groupKeys.length,
      child: Builder(builder: (context) {
        final tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          setState(() {
            _selectedGroupKey = _groupKeys[tabController.index];
          });
        });
        return Scaffold(
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
          floatingActionButton: FloatingActionButton(
            onPressed: () => _onGenerateWordImages(context),
            child: const FaIcon(FontAwesomeIcons.list),
          ),
        );
      }),
    );
  }

  _onGenerateWordImages(BuildContext context) {
    final words = _getWordsByKey(_selectedGroupKey);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VocabularyPreviewPage(
          words: words,
          title: widget.title,
          subtitle: _selectedGroupKey,
        ),
      ),
    );
  }

  Widget _buildGroupContent(String key) {
    final words = _getWordsByKey(key);
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(
            words[index].text,
            style: GoogleFonts.notoSansJp(
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

  _getWordsByKey(String key) {
    return widget.wordList.where((word) => word.category == key).toList();
  }
}
