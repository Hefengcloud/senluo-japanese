import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/common/enums/enums.dart';
import 'package:senluo_japanese_cms/pages/grammars/bloc/grammar_bloc.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/grammars/grammar_preview_page.dart';
import 'package:senluo_japanese_cms/pages/grammars/grammar_slide_page.dart';
import 'package:senluo_japanese_cms/pages/grammars/helpers/grammar_helper.dart';
import 'package:senluo_japanese_cms/pages/grammars/views/grammar_conjugation_text.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';
import 'package:senluo_japanese_cms/widgets/japanese_sentence.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/models/models.dart';
import '../../repos/grammars/models/grammar_entry.dart';

class GrammarDetailsPage extends StatelessWidget {
  final GrammarEntry entry;

  const GrammarDetailsPage({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrammarBloc, GrammarState>(
      builder: (context, state) {
        return Scaffold(
          appBar:
              state is GrammarLoaded && state.currentItem != GrammarItem.empty
                  ? AppBar(
                      title: Text(state.currentItem.key),
                      actions: _buildGeneratingActions(context, state),
                    )
                  : AppBar(title: Text(entry.level.name.toUpperCase())),
          body: state is GrammarLoaded && state.currentItem != GrammarItem.empty
              ? _buildBody(context, state)
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  _buildGeneratingActions(BuildContext context, GrammarLoaded state) {
    return [
      IconButton(
        icon: const Icon(Icons.edit_outlined),
        onPressed: () {
          _onEditItem(context, state.currentItem);
        },
      ),
      IconButton(
        icon: const Icon(Icons.copy_outlined),
        onPressed: () {
          _onCopyText(context, state.currentItem);
        },
      ),
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
    return Stack(
      children: [
        _buildGrammarDetails(context, state.currentItem),
        Positioned(
          left: 0,
          right: 0,
          bottom: 32,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _buildIndicators(context, state),
          ),
        ),
      ],
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
    return ListView(
      children: [
        const Gap(16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            item.name.split("/").join("\n"),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: kLevel2color[item.level],
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        _Subtitle(text: "意味", level: item.level),
        if (item.meaning.jp.isNotEmpty)
          ListTile(title: Text("🇯🇵 ${item.meaning.jp}")),
        if (item.meaning.zh.isNotEmpty)
          ListTile(title: Text("🇨🇳 ${item.meaning.zh}")),
        if (item.meaning.en.isNotEmpty)
          ListTile(title: Text("🇬🇧 ${item.meaning.en}")),
        _Subtitle(text: "接続", level: item.level),
        ...item.conjugations.map(
          (c) => ListTile(title: GrammarConjugationText(text: c)),
        ),
        if (item.explanations.isNotEmpty) ...[
          _Subtitle(text: "備考", level: item.level),
          if (item.explanations.isNotEmpty)
            ...item.explanations.map(
              (e) => ListTile(title: Text(e)),
            ),
        ],
        _Subtitle(text: "例文", level: item.level),
        ...item.examples.map(
          (e) => ListTile(title: _buildExampleText(context, e, item.level)),
        ),
        const Gap(48),
      ],
    );
  }

  _buildExampleText(BuildContext context, Example e, JLPTLevel level) {
    return JapaneseSentence(
      japanese: e.jp1.isNotEmpty ? e.jp1 : e.jp,
      translation: e.zh,
      fontSize: 16,
      emphasizedColor: kLevel2color[level]!,
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

  _onCopyText(BuildContext context, GrammarItem item) async {
    await Clipboard.setData(ClipboardData(text: item.text));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Text Copied')));
  }

  _onEditItem(BuildContext context, GrammarItem item) async {
    const baseUrl =
        'github://Hefengcloud/senluo_japanese_cms/tree/main/assets/grammar';
    final Uri url =
        Uri.parse('$baseUrl/${item.level.name.toLowerCase()}/${item.key}.yaml');
    print(url);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
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
        color: kLevel2color[level]?.withAlpha(30),
      ),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        "[$text]",
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
