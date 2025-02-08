import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

class GrammarDetailsPage extends StatelessWidget {
  final GrammarItem item;

  const GrammarDetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
    );
  }
}
