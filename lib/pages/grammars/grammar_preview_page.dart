import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';
import 'package:senluo_japanese_cms/constants/texts.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/texts.dart';
import 'package:senluo_japanese_cms/pages/grammars/helpers/grammar_helper.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_logo.dart';
import 'package:senluo_japanese_cms/widgets/sentence_text.dart';

import '../../constants/colors.dart';
import '../../helpers/image_helper.dart';
import 'bloc/grammar_item_bloc.dart';

class GrammarPreviewPage extends StatefulWidget {
  const GrammarPreviewPage({super.key});

  @override
  State<GrammarPreviewPage> createState() => _GrammarPreviewPageState();
}

class _GrammarPreviewPageState extends State<GrammarPreviewPage> {
  final GlobalKey globalKey = GlobalKey();

  double _fontSizeScaleFactor = 1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrammarItemBloc, GrammarItemState>(
      builder: (context, state) {
        if (state is GrammarItemLoaded) {
          return _buildBody(context, state);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildBody(BuildContext context, GrammarItemLoaded state) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _buildImage(state.displayedItem),
        ),
        const Gap(16),
        Expanded(
          flex: 2,
          child: Stack(
            children: [
              _buildRightPanel(context, state),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildBottomButtons(context, state),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildRightPanel(
    BuildContext context,
    GrammarItemLoaded state,
  ) {
    final item = state.item;
    final displayedItem = state.displayedItem;

    return ListView(
      children: [
        ExpansionTile(
          title: const Text(kTitleJpMeaning),
          children:
              item.meaning.jps.map((e) => ListTile(title: Text(e))).toList(),
        ),
        ExpansionTile(
          title: const Text(kTitleZhMeaning),
          children:
              item.meaning.zhs.map((e) => ListTile(title: Text(e))).toList(),
        ),
        ExpansionTile(
          title: const Text(kTitleEnMeaning),
          children:
              item.meaning.ens.map((e) => ListTile(title: Text(e))).toList(),
        ),
        ExpansionTile(
          title: const Text(kTitleConjugations),
          children:
              item.conjugations.map((e) => ListTile(title: Text(e))).toList(),
        ),
        ExpansionTile(
          title: const Text(kTitleExplanation),
          children:
              item.explanations.map((e) => ListTile(title: Text(e))).toList(),
        ),
        ExpansionTile(
          initiallyExpanded: true,
          title: const Text(kTitleExample),
          children: item.examples
              .map<ListTile>((e) => ListTile(
                    title: Text(e.jp),
                    subtitle: Text(e.zh),
                    leading: displayedItem.examples.contains(e)
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () => BlocProvider.of<GrammarItemBloc>(context).add(
                      GrammarExampleSelected(example: e),
                    ),
                  ))
              .toList(),
        ),
        const Gap(32),
      ],
    );
  }

  _buildBottomButtons(BuildContext context, GrammarItemLoaded state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Text('Font Size'),
            Expanded(
              child: Slider(
                label: _fontSizeScaleFactor.toStringAsFixed(1),
                value: _fontSizeScaleFactor,
                max: 2,
                min: 0.5,
                divisions: 15,
                onChanged: (value) {
                  setState(() {
                    _fontSizeScaleFactor = value;
                  });
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              onPressed: () => _onSaveImage(state.item.key),
              icon: const Icon(Icons.save),
              label: const Text('Save Image'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.abc),
              label: const Text('Copy Text'),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: state.item.text));
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Copied')));
              },
            )
          ],
        ),
      ],
    );
  }

  RepaintBoundary _buildImage(GrammarItem item) {
    final itemNameParts = item.parseName();
    final itemName = itemNameParts[0];
    final itemReading = itemNameParts.length > 1 ? itemNameParts[1] : null;

    return RepaintBoundary(
      key: globalKey,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/grammar-bg.png'),
              fit: BoxFit.cover,
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const Gap(16),
              _buildTopLogo(item),
              const Gap(16),
              _buildItemName(itemName, item.level),
              if (itemReading != null) _buildItemReading(itemReading),
              const Gap(8),
              _buildJpMeaning(item),
              const Gap(32),
              _buildZhMeaning(item),
              const Gap(32),
              _buildConjugation(item),
              const Gap(32),
              const Divider(
                height: 0.5,
                color: Colors.black12,
              ),
              const Gap(32),
              ..._buildExamples(item),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZhMeaning(GrammarItem item) {
    return AutoSizeText(
      item.meaning.zhs.join('；'),
      style: TextStyle(
        color: kLevel2color[item.level],
        fontSize: 24.0,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
    );
  }

  AutoSizeText _buildJpMeaning(GrammarItem item) {
    return AutoSizeText(
      item.meaning.jps.join('；'),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 20,
        color: kBrandColor,
      ),
      maxFontSize: 20,
      maxLines: 1,
    );
  }

  AutoSizeText _buildItemName(String itemName, JLPTLevel level) {
    final nameParts = itemName.split('/').map((e) => e.trim()).toList();
    return AutoSizeText(
      nameParts.join('\n'),
      maxLines: nameParts.length,
      style: GoogleFonts.getFont(
        'Rampart One',
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: kLevel2color[level],
      ),
    );
  }

  _buildItemReading(String itemReading) {
    return Text(
      itemReading,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 20,
      ),
    );
  }

  Container _buildConjugation(GrammarItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: kLevel2color[item.level]!.withOpacity(0.9),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            item.conjugations.map((e) => _buildConjugationText(e)).toList(),
      ),
    );
  }

  Widget _buildConjugationText(String text) {
    RegExp pattern = RegExp(r'(.*?)(~~.*?~~)(.*)');
    Match? match = pattern.firstMatch(text);
    const style = TextStyle(
      color: Colors.white,
      fontSize: 20,
    );

    if (match != null) {
      String textBefore = match.group(1) ?? "";
      String textDeleted = match.group(2) ?? "";
      String textAfter = match.group(3) ?? "";
      return Text.rich(
        TextSpan(children: [
          TextSpan(text: textBefore, style: style),
          TextSpan(
            text: textDeleted.replaceAll('~', ''),
            style: style.copyWith(
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.white,
              decorationThickness: 2,
            ),
          ),
          TextSpan(text: textAfter, style: style),
        ]),
      );
    } else {
      return Text(text, style: style);
    }
  }

  _buildTopLogo(GrammarItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const EverJapanLogo(),
        Chip(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: kLevel2color[item.level]!),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          label: Text(
            'JLPT ${item.level.name.toUpperCase()}',
            style: TextStyle(color: kLevel2color[item.level]),
          ),
        ),
      ],
    );
  }

  _buildExamples(GrammarItem item) {
    final theExamples =
        item.examples.isNotEmpty ? item.examples : item.examples.take(2);
    return theExamples
        .map((e) => Padding(
              padding: const EdgeInsets.only(
                bottom: 0.0,
              ),
              child: SentenceText(
                fontSize: 24.0 * _fontSizeScaleFactor,
                lines: [e.jp, e.zh],
                emphasizedColor: kLevel2color[item.level]!,
                textAlign: TextAlign.left,
                multipleLines: false,
              ),
            ))
        .toList();
  }

  _onSaveImage(String fileName) async {
    final bytes = await captureWidget(globalKey);
    saveImageToFile(bytes!, '$fileName.jpg');
  }
}
