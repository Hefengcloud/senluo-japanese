import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_example_list_view.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_meaning_list_view.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_title_view.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_logo.dart';

import '../../grammars/constants/texts.dart';

enum PreviewType {
  full(value: 'Full'),
  meanings(value: 'Meanings'),
  examples(value: 'Examples');

  final String value;

  const PreviewType({required this.value});
}

class ItemDisplayView extends StatefulWidget {
  final Onomatopoeia item;

  const ItemDisplayView({super.key, required this.item});

  @override
  State<ItemDisplayView> createState() => _ItemDisplayViewState();
}

class _ItemDisplayViewState extends State<ItemDisplayView> {
  static const _kMainColor = kColorN1;

  final Map<PreviewType, Widget> _tabs = {};
  final Map<PreviewType, Widget> _previews = {};

  var _previewType = PreviewType.full;

  List<Example> _examples = [];

  @override
  void initState() {
    super.initState();
    _tabs[PreviewType.full] = _buildFullText(context);
    _tabs[PreviewType.meanings] = _buildMeaningsText(context);
    _tabs[PreviewType.examples] = _buildExamplesText(context);

    _previews[PreviewType.full] = _buildFullPreview(context);
    _previews[PreviewType.meanings] = _buildMeaningsPreview(context);
    _previews[PreviewType.examples] = _buildExamplesPreview(context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 3, child: _buildLeft(context)),
        Expanded(flex: 2, child: _buildRight(context)),
      ],
    );
  }

  _buildLeft(BuildContext context) {
    switch (_previewType) {
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
      length: _tabs.length,
      child: Builder(builder: (context) {
        final controller = DefaultTabController.of(context);
        controller.addListener(() {
          setState(() {
            _previewType = _tabs.keys.toList()[controller.index];
          });
        });
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
                tabs: _tabs.entries
                    .map(
                      (e) => Tab(text: e.key.value),
                    )
                    .toList()),
            const Gap(32),
            Expanded(
              child: TabBarView(
                children: _tabs.entries
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: e.value,
                      ),
                    )
                    .toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.image),
                  label: const Text('Save Image'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
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

  _buildFullText(BuildContext context) {
    final item = widget.item;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Text(_generateFullText(item)),
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
                tileColor: _examples.contains(e) ? _kMainColor : null,
                textColor: _examples.contains(e) ? Colors.white : Colors.black,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(kTitleJpMeaning),
        ...widget.item.meanings['jp']!
            .map((e) => ListTile(
                  title: Text(e),
                ))
            .toList(),
        _buildTitle(kTitleEnMeaning),
        ...widget.item.meanings['en']!
            .map((e) => ListTile(
                  title: Text(e),
                ))
            .toList(),
        _buildTitle(kTitleZhMeaning),
        ...widget.item.meanings['zh']!
            .map((e) => ListTile(
                  title: Text(e),
                ))
            .toList(),
      ],
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
    );
  }

  _buildExamplesPreview(BuildContext context) {
    return ItemExampleListView(
      item: widget.item,
      mainColor: _kMainColor,
    );
  }

  AspectRatio _buildFullPreview(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Card(
        child: Column(
          children: [
            const Gap(32),
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
                widget.item.meanings['zh']?.join('。') ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
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

$kTitleEnMeaning
${item.meanings['en']?.map((e) => '- $e').toList().join('\n')}

$kTitleZhMeaning
${item.meanings['zh']?.map((e) => '- $e').toList().join('\n')}

$kTitleExample
${item.examples.map((e) => "◎ ${e['jp']}\n→ ${e['en']}\n→ ${e['zh']}\n").toList().join('\n')}
""";
  }
}
