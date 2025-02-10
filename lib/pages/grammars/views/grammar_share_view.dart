import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/grammars/helpers/grammar_helper.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_logo.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_watermark.dart';

import '../../../common/constants/colors.dart';
import '../../../common/helpers/image_helper.dart';
import '../../../common/models/models.dart';
import '../../../widgets/sentence_html_text.dart';

class GrammarShareView extends StatefulWidget {
  final GrammarItem item;

  const GrammarShareView({super.key, required this.item});

  @override
  State<GrammarShareView> createState() => _GrammarShareViewState();
}

class _GrammarShareViewState extends State<GrammarShareView> {
  final GlobalKey _globalKey = GlobalKey();

  late List<Example> _examples;

  double _dividerGap = 0.0; // 分割线高度

  final List<bool> _checkedItems = [false, false, false]; // 复选框状态

  @override
  Widget build(BuildContext context) {
    _examples = widget.item.examples;
    return _buildImageContainer(context);
  }

  _buildImageContainer(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 480,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImage(widget.item),
            _buildBottomActions(context),
          ],
        ),
      );

  RepaintBoundary _buildImage(GrammarItem item) {
    return RepaintBoundary(
      key: _globalKey,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
          padding: const EdgeInsets.all(8),
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
                const Gap(4),
                _buildItemName(item.name, item.level),
                _buildJpMeaning(item),
                const Gap(4),
                _buildZhMeaning(item),
                const Gap(4),
                _buildConjugation(item),
                _buildDivider(context),
                Expanded(child: _buildExampleList(item)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildDivider(BuildContext context) => Container(
        width: 48,
        margin: EdgeInsets.only(
          top: 8 + _dividerGap,
          bottom: _dividerGap,
        ),
        child: const Divider(
          height: 0.5,
          color: Colors.black12,
        ),
      );

  Widget _buildZhMeaning(GrammarItem item) {
    return AutoSizeText(
      item.meaning.zhs.join('；'),
      style: TextStyle(
        color: kLevel2color[item.level],
        fontSize: 10,
      ),
      textAlign: TextAlign.center,
      maxFontSize: 12,
      maxLines: 1,
    );
  }

  AutoSizeText _buildJpMeaning(GrammarItem item) {
    return AutoSizeText(
      item.meaning.jps.join('\n'),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 10,
        color: kBrandColor,
      ),
      maxFontSize: 12,
    );
  }

  AutoSizeText _buildItemName(String itemName, JLPTLevel level) {
    final nameParts = itemName.split('/').map((e) => e.trim()).toList();
    return AutoSizeText(
      nameParts.join('\n'),
      maxLines: nameParts.length,
      style: GoogleFonts.getFont(
        'Klee One',
        fontSize: 48 - (nameParts.length - 1) * 8,
        fontWeight: FontWeight.bold,
        color: kLevel2color[level],
      ),
    );
  }

  Container _buildConjugation(GrammarItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: kLevel2color[item.level]!.withOpacity(0.9),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
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
      fontVariations: [FontVariation.weight(700)],
      fontSize: 12,
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
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            'JLPT ${item.level.name.toUpperCase()}',
            style: GoogleFonts.getFont(
              'Montserrat',
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const EverJapanLogo(),
      ],
    );
  }

  _buildExampleList(GrammarItem item) {
    return InkWell(
      onLongPress: () => _onSelectExamples(context),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final e = item.examples[index];
          return SentenceHtmlText(
            original: e.jp,
            formated: e.jp1,
            translated: e.zh,
            emphasizedColor: kLevel2color[item.level]!,
          );
        },
        itemCount: item.examples.length,
      ),
    );
  }

  _onSaveImage(String fileName) async {
    final bytes = await captureWidget(_globalKey);
    saveImageToFile(bytes!, '$fileName.jpg');
  }

  _onCopyText() async {
    await Clipboard.setData(ClipboardData(text: widget.item.text));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Copied')));
  }

  _onSetLayout() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            Row(
              children: [
                const Text('Divider Height:'),
                Slider(
                  value: _dividerGap,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  onChanged: (value) => setState(() {
                    _dividerGap = value;
                  }),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _onSelectExamples(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16)), // 圆角
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // 适应内容大小
                children: [
                  const Text(
                    "选择例句",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  ..._examples.map<CheckboxListTile>(
                    (e) => CheckboxListTile(
                      title: Text(
                        e.jp,
                        style: const TextStyle(fontSize: 12),
                      ),
                      onChanged: (bool? value) {
                        setState(() {
                          _checkedItems[0] = value!;
                        });
                      },
                      value: true,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  _buildBottomActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          tooltip: 'Show examples',
          icon: const Icon(Icons.list_outlined),
          onPressed: () => _onSelectExamples(context),
        ),
        IconButton(
          tooltip: 'Set layout',
          icon: const Icon(Icons.margin_outlined),
          onPressed: () => _onSetLayout(),
        ),
        IconButton(
          tooltip: 'Save image',
          icon: const Icon(Icons.save_outlined),
          onPressed: () => _onSelectExamples(context),
        ),
        IconButton(
          tooltip: 'Copy Text',
          icon: const Icon(Icons.copy_outlined),
          onPressed: _onCopyText,
        ),
      ],
    );
  }
}
