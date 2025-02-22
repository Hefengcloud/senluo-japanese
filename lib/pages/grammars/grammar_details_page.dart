import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/common/enums/enums.dart';
import 'package:senluo_japanese_cms/pages/grammars/bloc/grammar_bloc.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/grammars/grammar_preview_page.dart';
import 'package:senluo_japanese_cms/pages/grammars/grammar_slide_page.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';
import 'package:senluo_japanese_cms/widgets/sentence_plain_text.dart';

import '../../common/constants/fonts.dart';
import '../../repos/grammars/models/grammar_entry.dart';

class GrammarDetailsPage extends StatelessWidget {
  final GrammarEntry entry;

  const GrammarDetailsPage({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrammarBloc, GrammarState>(
      builder: (context, state) {
        final levelStr = entry.level.name.toUpperCase();
        return Scaffold(
          appBar:
              state is GrammarLoaded && state.currentItem != GrammarItem.empty
                  ? AppBar(
                      title: Text("$levelStr "),
                      actions: _buildGeneratingActions(context, state),
                    )
                  : AppBar(title: Text(entry.level.name.toUpperCase())),
          body: state is GrammarLoaded && state.currentItem != GrammarItem.empty
              ? _buildBody(context, state)
              : const Center(child: CircularProgressIndicator()),
          bottomNavigationBar:
              state is GrammarLoaded && state.currentItem != GrammarItem.empty
                  ? _buildBottomAppBar(context, state)
                  : null,
        );
      },
    );
  }

  _buildGeneratingActions(BuildContext context, GrammarLoaded state) {
    return [
      IconButton(
        icon: const Icon(Icons.animation_outlined),
        onPressed: () {
          _onGenerateAnimation(context, state.currentItem);
        },
      ),
      IconButton(
        icon: const Icon(Icons.image_outlined),
        onPressed: () {
          _onGenerateImage(context, state.currentItem);
        },
      ),
    ];
  }

  _buildBody(BuildContext context, GrammarLoaded state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildGrammarDetails(context, state.currentItem),
      ),
    );
  }

  _buildIndicators(BuildContext context, GrammarLoaded state) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Theme.of(context).primaryColor.withAlpha(128),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Previous',
            icon: const Icon(
              Icons.arrow_left,
              color: Colors.white,
            ),
            onPressed: () {
              context
                  .read<GrammarBloc>()
                  .add(const GrammarItemChanged(previous: true));
            },
          ),
          SizedBox(
            width: 72,
            child: Text(
              "${state.currentIndex + 1} / ${state.entries.length}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Next',
            icon: const Icon(
              Icons.arrow_right,
              color: Colors.white,
            ),
            onPressed: () {
              context
                  .read<GrammarBloc>()
                  .add(const GrammarItemChanged(previous: false));
            },
          ),
        ],
      ),
    );
  }

  _buildGrammarDetails(BuildContext context, GrammarItem item) {
    return Column(
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
          (e) => SentencePlainText(
            mainStyle: const TextStyle(
              fontFamily: kLocalZHFont,
            ),
            lines: [e.jp, e.zh, e.en],
            emphasizedColor: kLevel2color[item.level] ?? Colors.black,
          ),
        ),
      ],
    );
  }

  _buildBottomAppBar(BuildContext context, GrammarLoaded state) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildIndicators(context, state),
        ],
      ),
    );
  }

  _onGenerateImage(BuildContext context, GrammarItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => RepositoryProvider(
          create: (BuildContext context) {
            return context.read<GrammarBloc>().grammarRepository;
          },
          child: GrammarPreviewPage(item: item),
        ),
      ),
    );
  }

  _onGenerateAnimation(BuildContext context, GrammarItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return GrammarSlidePage(item: item);
        },
        fullscreenDialog: true,
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
