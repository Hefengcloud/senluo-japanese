import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/common/enums/enums.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/constants/constants.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';
import 'package:senluo_japanese_cms/widgets/example_sentence_text.dart';

class GrammarDetailsPage extends StatelessWidget {
  final GrammarItem item;

  const GrammarDetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("JLPT ${item.level.name.toUpperCase()} 文法"),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: null,
        child: const Icon(Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: kLevel2color[item.level],
                    fontWeight: FontWeight.bold,
                  ),
            ),
            _Subtitle(text: "意味", level: item.level),
            Text("🇯🇵 ${item.meaning.jp}"),
            Text("🇨🇳 ${item.meaning.zh}"),
            Text("🇬🇧 ${item.meaning.en}"),
            const Gap(16),
            _Subtitle(text: "例文", level: item.level),
            ...item.examples.map(
              (e) => ExampleSentenceText(
                mainStyle: const TextStyle(
                  fontFamily: kZhFont,
                ),
                lines: [e.jp, e.zh, e.en],
                emphasizedColor: kLevel2color[item.level] ?? Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildBottomAppBar() {
    return BottomAppBar(
      child: Row(
        children: <Widget>[
          IconButton(
            tooltip: 'Save as image',
            icon: const Icon(Icons.image_outlined),
            onPressed: () {},
          ),
          IconButton(
            tooltip: 'Copy Text',
            icon: const Icon(Icons.copy),
            onPressed: () {},
          ),
          IconButton(
            tooltip: 'Choose examples',
            icon: const Icon(Icons.list),
            onPressed: () {},
          ),
          IconButton(
            tooltip: 'Layout settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  final String text;
  final JLPTLevel level;

  const _Subtitle({required this.text, required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: kLevel2color[level],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
