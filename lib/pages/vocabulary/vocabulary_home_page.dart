import 'package:flutter/material.dart';
import 'package:senluo_goi/senluo_goi.dart';
import 'package:senluo_japanese_cms/pages/vocabulary/vocabulary_category_page.dart';
import 'package:senluo_japanese_cms/pages/vocabulary/jlpt/vocabulary_jlpt_page.dart';
import 'package:senluo_japanese_cms/pages/vocabulary/textbook/vocabulary_textbook_page.dart';

class VocabularyHomePage extends StatelessWidget {
  const VocabularyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const types = VocabularyType.values;
    return DefaultTabController(
      length: VocabularyType.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("語彙"),
          bottom: TabBar(
            tabs: VocabularyType.values
                .map<Tab>(
                  (e) => Tab(text: e.text),
                )
                .toList(),
          ),
        ),
        body: TabBarView(
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
