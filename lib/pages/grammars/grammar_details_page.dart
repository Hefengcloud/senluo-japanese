import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_bunpo/senluo_bunpo.dart';
import 'package:senluo_japanese_cms/pages/grammars/bloc/grammar_bloc.dart';
import 'package:senluo_japanese_cms/pages/grammars/grammar_preview_page.dart';
import 'package:senluo_japanese_cms/pages/grammars/grammar_slide_page.dart';
import 'package:url_launcher/url_launcher.dart';

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
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: GrammarDetailView(item: state.currentItem),
        ),
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
              "${state.currentItemIndex + 1} / ${state.currentLevelEntries.length}",
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
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
