import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/vocabulary/vocabulary_category_page.dart';
import 'package:senluo_japanese_cms/pages/vocabulary/jlpt/vocabulary_jlpt_page.dart';
import 'package:senluo_japanese_cms/pages/vocabulary/textbook/vocabulary_textbook_page.dart';
import 'package:senluo_japanese_cms/repos/vocabulary/vocabulary_repository.dart';

class VocabularyHomePage extends StatefulWidget {
  const VocabularyHomePage({super.key});

  @override
  State<VocabularyHomePage> createState() => _VocabularyHomePageState();
}

class _VocabularyHomePageState extends State<VocabularyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: VocabularyType.values.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const types = VocabularyType.values;
    return DefaultTabController(
      length: VocabularyType.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("語彙"),
          bottom: TabBar(
            tabs: VocabularyType.values
                .map<Tab>(
                  (e) => Tab(text: e.text),
                )
                .toList(),
            controller: _tabController,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: types.map(
            (type) {
              if (type == VocabularyType.category) {
                return const VocabularyCategoryPage();
              } else if (type == VocabularyType.jlpt) {
                return const VocabularyJlptPage();
              } else if (type == VocabularyType.textbook) {
                return const VocabularyTextbookPage();
              }
              return Text(type.text);
            },
          ).toList(),
        ),
      ),
    );
  }
}
