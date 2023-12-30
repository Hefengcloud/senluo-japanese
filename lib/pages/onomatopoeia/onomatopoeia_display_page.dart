import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/helpers/image_helper.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_example_list_view.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_meaning_list_view.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_logo.dart';

import '../grammars/constants/texts.dart';

enum PreviewType {
  full(value: 'Full'),
  meanings(value: 'Meanings'),
  examples(value: 'Examples');

  final String value;

  const PreviewType({required this.value});
}

class ItemDisplayPage extends StatefulWidget {
  final Onomatopoeia item;

  const ItemDisplayPage({super.key, required this.item});

  @override
  State<ItemDisplayPage> createState() => _ItemDisplayPageState();
}

class _ItemDisplayPageState extends State<ItemDisplayPage> {
  static const _kMainColor = kColorN1;
  final GlobalKey globalKey = GlobalKey();

  final _previewTypes = <PreviewType>[
    PreviewType.full,
    PreviewType.meanings,
    PreviewType.examples,
  ];

  var _currentType = PreviewType.full;

  List<Example> _examples = [];

  double _fontSizeScaleFactor = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: RepaintBoundary(
            key: globalKey,
            child: _buildLeft(context),
          ),
        ),
        Expanded(flex: 2, child: _buildRight(context)),
      ],
    );
  }

  _buildLeft(BuildContext context) {
    switch (_currentType) {
      case PreviewType.full:
        return _buildFullPreview(context);
      case PreviewType.meanings:
        return _buildMeaningsPreview(context);
      case PreviewType.examples:
        return _buildExamplesPreview(context);
    }
  }

  _buildRight(BuildContext context) {
    return DefaultTabController(
      length: _previewTypes.length,
      child: Builder(builder: (context) {
        final controller = DefaultTabController.of(context);
        controller.addListener(() {
          setState(() {
            _currentType = _previewTypes[controller.index];
          });
        });
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(tabs: _previewTypes.map((e) => Tab(text: e.value)).toList()),
            const Gap(32),
            Expanded(
              child: TabBarView(
                children: _previewTypes
                    .map<Widget>((type) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: _buildTabbarView(type),
                        ))
                    .toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _saveImage(),
                  icon: const Icon(Icons.image),
                  label: const Text('Save Image'),
                ),
                if (_currentType == PreviewType.full)
                  ElevatedButton.icon(
                    onPressed: () => _copyText(),
                    icon: const Icon(Icons.abc),
                    label: const Text('Copy Text'),
                  ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTabbarView(PreviewType type) {
    switch (type) {
      case PreviewType.full:
        return _buildFullText(context);
      case PreviewType.meanings:
        return _buildMeaningsText(context);
      case PreviewType.examples:
        return _buildExamplesText(context);
    }
  }

  _copyText() async {
    final text = _generateFullText(widget.item);
    await Clipboard.setData(ClipboardData(text: text));
  }

  _saveImage() async {
    final bytes = await captureWidget(globalKey);
    if (bytes != null) {
      await saveImageToFile(
        bytes,
        '${widget.item.key}-${_currentType.value.toLowerCase()}.jpg',
      );
    }
  }

  _buildFullText(BuildContext context) {
    final item = widget.item;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SelectableText(_generateFullText(item)),
    );
  }

  _buildExamplesText(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.item.examples
          .map((e) => ListTile(
                title: Text(e['jp'] ?? ''),
                subtitle: Text(e['en'] ?? ''),
                leading: _examples.contains(e) ? const Icon(Icons.check) : null,
                // leading: const Icon(Icons.check),
                onTap: () {
                  final examples = List<Example>.from(_examples);
                  if (examples.contains(e)) {
                    examples.remove(e);
                  } else {
                    examples.add(e);
                  }
                  setState(() {
                    _examples = examples;
                  });
                },
              ))
          .toList(),
    );
  }

  _buildMeaningsText(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(kTitleJpMeaning),
          ...widget.item.meanings['jp']!.map((e) => Text(e)).toList(),
          const Gap(16),
          _buildTitle(kTitleZhMeaning),
          ...widget.item.meanings['zh']!.map((e) => Text(e)).toList(),
          const Gap(16),
          _buildTitle(kTitleEnMeaning),
          ...widget.item.meanings['en']!.map((e) => Text(e)).toList(),
          const Gap(32),
          const Divider(height: 1),
          const Gap(32),
          _buildTitle('Font Size'),
          Slider(
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
        ],
      ),
    );
  }

  _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  _buildMeaningsPreview(BuildContext context) {
    final item = widget.item;
    return ItemMeaningListView(
      item: item,
      mainColor: _kMainColor,
      fontSize: 20 * _fontSizeScaleFactor,
    );
  }

  _buildExamplesPreview(BuildContext context) {
    return ItemExampleListView(
      item: widget.item,
      mainColor: _kMainColor,
      examples: _examples,
    );
  }

  AspectRatio _buildFullPreview(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            const Gap(128),
            Expanded(
              child: Image.asset(
                'assets/onomatopoeia/images/${widget.item.key}.png',
              ),
            ),
            const Gap(32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: _buildItemTitle(fontSize: 96.0),
            ),
            const Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: AutoSizeText(
                "${widget.item.meanings['zh']?.join('；') ?? ''}。",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
                maxLines: 1,
              ),
            ),
            const Gap(128),
            const EverJapanLogo(),
            const Gap(32),
          ],
        ),
      ),
    );
  }

  AutoSizeText _buildItemTitle({double? fontSize}) {
    return AutoSizeText(
      widget.item.name,
      style: GoogleFonts.getFont(
        'Rampart One',
        fontSize: fontSize,
        color: _kMainColor,
      ),
      maxLines: 1,
    );
  }

  _generateFullText(Onomatopoeia item) {
    return """
拟声拟态词 | ${item.name}

$kTitleJpMeaning
${item.meanings['jp']?.map((e) => '- $e').toList().join('\n')}

$kTitleZhMeaning
${item.meanings['zh']?.map((e) => '- $e').toList().join('\n')}

$kTitleEnMeaning
${item.meanings['en']?.map((e) => '- $e').toList().join('\n')}

$kTitleExample
${item.examples.map((e) => "◎ ${e['jp']}\n→ ${e['en']}\n→ ${e['zh']}\n").toList().join('\n')}
""";
  }
}
