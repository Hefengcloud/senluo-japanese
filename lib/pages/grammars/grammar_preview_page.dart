import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/common/constants/number_constants.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';
import 'package:senluo_japanese_cms/constants/texts.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/texts.dart';
import 'package:senluo_japanese_cms/pages/grammars/helpers/grammar_helper.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_logo.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_watermark.dart';

import '../../constants/colors.dart';
import '../../helpers/image_helper.dart';
import '../../widgets/example_sentence_text.dart';
import 'bloc/grammar_item_bloc.dart';

class GrammarPreviewPage extends StatefulWidget {
  const GrammarPreviewPage({super.key});

  @override
  State<GrammarPreviewPage> createState() => _GrammarPreviewPageState();
}

class _GrammarPreviewPageState extends State<GrammarPreviewPage> {
  final GlobalKey _globalKey = GlobalKey();

  double _gap = 16.0;

  static const _kJpFont = 'Roboto';
  static const _kZhFont = 'Roboto';

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
          flex: kPreviewLeftFlex,
          child: _buildImage(state.displayedItem),
        ),
        const Gap(16),
        Expanded(
          flex: kPreviewRightFlex,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: _buildRightPanel(context, state),
              ),
              _buildBottomButtons(context, state),
            ],
          ),
        ),
      ],
    );
  }

  _buildRightPanel(BuildContext context, GrammarItemLoaded state) {
    final item = state.item;
    final displayedItem = state.displayedItem;

    return ListView(
      children: [
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
      ],
    );
  }

  _buildBottomButtons(BuildContext context, GrammarItemLoaded state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Text('Gap'),
            Expanded(
              child: Slider(
                label: _gap.toStringAsFixed(0),
                value: _gap,
                max: 48,
                min: 8,
                divisions: 5,
                onChanged: (value) {
                  setState(() {
                    _gap = value;
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
    return RepaintBoundary(
      key: _globalKey,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/grammar-bg.png'),
              fit: BoxFit.cover,
            ),
            color: Colors.white,
          ),
          child: EverjapanWatermark(
            child: Column(
              children: [
                _buildTopLogo(item),
                Gap(_gap),
                _buildItemName(item.name, item.level),
                _buildJpMeaning(item),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: _gap,
                  ),
                  child: _buildZhMeaning(item),
                ),
                _buildConjugation(item),
                Gap(_gap),
                const Divider(
                  height: 0.5,
                  color: Colors.black12,
                ),
                const Gap(16),
                Expanded(child: _buildExampleList(item)),
              ],
            ),
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
        fontSize: 20.0,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
    );
  }

  AutoSizeText _buildJpMeaning(GrammarItem item) {
    return AutoSizeText(
      item.meaning.jps.join('\n'),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14,
        color: kBrandColor,
      ),
      maxFontSize: 16,
    );
  }

  AutoSizeText _buildItemName(String itemName, JLPTLevel level) {
    final nameParts = itemName.split('/').map((e) => e.trim()).toList();
    return AutoSizeText(
      nameParts.join('\n'),
      maxLines: nameParts.length,
      style: GoogleFonts.getFont(
        'Klee One',
        fontSize: 64 - (nameParts.length - 1) * 8,
        fontWeight: FontWeight.bold,
        color: kLevel2color[level],
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
      fontSize: 16,
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
        Container(
          decoration: BoxDecoration(
            color: kLevel2color[item.level],
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'JLPT ${item.level.name.toUpperCase()}',
            style: GoogleFonts.getFont(
              'Montserrat',
              color: Colors.white,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const EverJapanLogo(),
      ],
    );
  }

  _buildExampleList(GrammarItem item) => ListView(
        children: item.examples
            .mapIndexed(
              (index, e) => ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                leading: Icon(
                  Icons.trip_origin,
                  color: kLevel2color[item.level]!,
                  size: 10,
                ),
                title: ExampleSentenceText(
                  lines: [e.jp],
                  emphasizedColor: kLevel2color[item.level]!,
                ),
                subtitle: e.zh.isNotEmpty ? Text(e.zh) : null,
              ),
            )
            .toList(),
      );

  _onSaveImage(String fileName) async {
    final bytes = await captureWidget(_globalKey);
    saveImageToFile(bytes!, '$fileName.jpg');
  }
}
