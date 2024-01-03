import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/vocabulary/views/vocabulary_category_list_view.dart';

class VocabularyPanelPage extends StatelessWidget {
  const VocabularyPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vocabulary')),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: VocabularyCategoryListView(),
          ),
          Expanded(
            flex: 3,
            child: Placeholder(),
          )
        ],
      ),
    );
  }
}
