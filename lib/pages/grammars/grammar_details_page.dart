import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/common/enums/enums.dart';
import 'package:senluo_japanese_cms/pages/grammars/bloc/grammar_bloc.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/grammars/grammar_preview_page.dart';
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
      bottomNavigationBar: _buildBottomAppBar(context),
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
            const Gap(8),
            _Subtitle(text: "意味", level: item.level),
            if (item.meaning.jp.isNotEmpty) Text("🇯🇵 ${item.meaning.jp}"),
            if (item.meaning.zh.isNotEmpty) Text("🇨🇳 ${item.meaning.zh}"),
            if (item.meaning.en.isNotEmpty) Text("🇬🇧 ${item.meaning.en}"),
            _Subtitle(text: "接続", level: item.level),
            ...item.conjugations.map(
              (c) => Text(c),
            ),
            const Gap(8),
            if (item.explanations.isNotEmpty) ...[
              _Subtitle(text: "備考", level: item.level),
              if (item.explanations.isNotEmpty)
                ...item.explanations.map(
                  (e) => Text(e),
                ),
              const Gap(8),
            ],
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

  _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        children: <Widget>[
          IconButton(
            tooltip: 'Previous',
            icon: const Icon(Icons.arrow_back_outlined),
            onPressed: () {},
          ),
          IconButton(
            tooltip: 'Next',
            icon: const Icon(Icons.arrow_forward_outlined),
            onPressed: () {},
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.animation_outlined),
            onPressed: () {
              _onGenerateAnimation(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.image_outlined),
            onPressed: () {
              _onGenerateImage(context);
            },
          ),
        ],
      ),
    );
  }

  _onGenerateImage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RepositoryProvider(
          create: (BuildContext context) {
            return context.read<GrammarBloc>().grammarRepository;
          },
          child: GrammarPreviewPage(item: item),
        ),
      ),
    );
  }

  _onGenerateAnimation(BuildContext context) {}
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
