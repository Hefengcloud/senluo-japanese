import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/grammars/helpers/grammar_helper.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

class GrammarTextView extends StatelessWidget {
  final GrammarItem item;

  const GrammarTextView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Text(item.text);
  }
}
