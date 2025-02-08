import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';
import 'package:senluo_japanese_cms/common/constants/texts.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/texts.dart';
import 'package:senluo_japanese_cms/pages/grammars/helpers/grammar_helper.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_logo.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_watermark.dart';

import '../../common/constants/colors.dart';
import '../../common/helpers/image_helper.dart';
import '../../common/models/models.dart';
import '../../widgets/sentence_html_text.dart';

class GrammarPreviewView extends StatefulWidget {
  final GrammarItem item;

  const GrammarPreviewView({super.key, required this.item});

  @override
  State<GrammarPreviewView> createState() => _GrammarPreviewViewState();
}

class _GrammarPreviewViewState extends State<GrammarPreviewView> {
  final GlobalKey _globalKey = GlobalKey();

  late List<Example> _examples;

  double _gap = 16.0;
  double _imageWidth = 480.0;

  final List<bool> _checkedItems = [false, false, false]; // 复选框状态

  @override
  Widget build(BuildContext context) {
    _examples = widget.item.examples;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.image),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: _buildImageContainer(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: null,
        child: const Icon(Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  _buildImageContainer(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 480,
        ),
        child: _buildImage(widget.item),
      );

  _buildRightPanel(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: const Text(kTitleSettings),
          children: [
            const Row(
              children: [
                Text('Aspect Ratio: 4/3'),
              ],
            ),
            Row(
              children: [
                const Text('Image Width'),
                Slider(
                  min: 360,
                  max: 720,
                  divisions: 36,
                  value: _imageWidth,
                  onChanged: (value) {
                    setState(() {
                      _imageWidth = value;
                    });
                  },
                ),
                Text("$_imageWidth"),
              ],
            ),
          ],
        ),
        ExpansionTile(
          initiallyExpanded: true,
          title: const Text(kTitleExample),
          children: _examples
              .map<ListTile>(
                (e) => ListTile(
                    title: Text(e.jp),
                    subtitle: Text(e.zh),
                    leading: widget.item.examples.contains(e)
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () {
                      if (_examples.contains(e)) {
                        _examples.remove(e);
                      } else {
                        _examples.add(e);
                      }
                    }),
              )
              .toList(),
        ),
        ExpansionTile(
          title: const Text(kTitleJpMeaning),
          children: widget.item.meaning.jps
              .map((e) => ListTile(title: Text(e)))
              .toList(),
        ),
        ExpansionTile(
          title: const Text(kTitleZhMeaning),
          children: widget.item.meaning.zhs
              .map((e) => ListTile(title: Text(e)))
              .toList(),
        ),
        ExpansionTile(
          title: const Text(kTitleEnMeaning),
          children: widget.item.meaning.ens
              .map((e) => ListTile(title: Text(e)))
              .toList(),
        ),
        ExpansionTile(
          title: const Text(kTitleConjugations),
          children: widget.item.conjugations
              .map((e) => ListTile(title: Text(e)))
              .toList(),
        ),
        ExpansionTile(
          title: const Text(kTitleExplanation),
          children: widget.item.explanations
              .map((e) => ListTile(title: Text(e)))
              .toList(),
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
                const Gap(8),
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
        fontSize: 16.0,
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
        fontSize: 60 - (nameParts.length - 1) * 8,
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
      fontSize: 14,
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
      onLongPress: () {
        _showExampleList();
      },
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          final e = item.examples[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            minVerticalPadding: 0,
            title: SentenceHtmlText(
              original: e.jp,
              formated: e.jp1,
              translated: e.zh,
              emphasizedColor: kLevel2color[item.level]!,
            ),
          );
        },
        itemCount: item.examples.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 1,
            color: Colors.grey[50],
          );
        },
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

  _showExampleList() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.amber,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Modal BottomSheet'),
                ElevatedButton(
                  child: const Text('Close BottomSheet'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showExamples(BuildContext context) {
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  ..._examples.map<CheckboxListTile>(
                    (e) => CheckboxListTile(
                      title: Text(e.jp),
                      onChanged: (bool? value) {
                        setState(() {
                          _checkedItems[0] = value!;
                        });
                      },
                      value: true,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("确定"),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  _buildBottomAppBar() {
    return BottomAppBar(
      child: Row(
        children: <Widget>[
          IconButton(
            tooltip: 'Save as image',
            icon: const Icon(Icons.image_outlined),
            onPressed: () {
              _onSaveImage(widget.item.key);
            },
          ),
          IconButton(
            tooltip: 'Copy Text',
            icon: const Icon(Icons.copy),
            onPressed: () {
              _onCopyText();
            },
          ),
          IconButton(
            tooltip: 'Choose examples',
            icon: const Icon(Icons.list),
            onPressed: () {
              _showExamples(context);
            },
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
