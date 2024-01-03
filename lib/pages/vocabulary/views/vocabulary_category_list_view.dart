import 'package:flutter/material.dart';

class VocabularyCategoryListView extends StatelessWidget {
  const VocabularyCategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('JLPT単語'),
        ),
        ListTile(
          title: Text('教科書の単語'),
        ),
        ListTile(
          title: Text('カテゴリー別 単語'),
        ),
        ListTile(
          title: Text('その他の単語'),
        ),
      ],
    );
  }
}
