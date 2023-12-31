import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/constants/colors.dart';
import 'package:senluo_japanese_cms/helpers/image_helper.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/constants/contants.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_examples_preview_view.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_examples_text_view.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_full_preview_view.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_full_text_view.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_meanings_preview_view.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_meanings_text_view.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';

import '../../widgets/everjapan_logo.dart';
import 'helpers/item_text_helper.dart';

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
  final GlobalKey globalKey = GlobalKey();

  final _previewTypes = <PreviewType>[
    PreviewType.full,
    PreviewType.meanings,
    PreviewType.examples,
  ];

  var _currentType = PreviewType.full;

  List<Example> _examples = [];

  double _fontSizeScaleFactor = 1;
  bool? _showBorder = false;

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
    final item = widget.item;
    switch (_currentType) {
      case PreviewType.full:
        return _buildPreviewView(
          child: ItemFullPreviewView(
            item: item,
            fontSizeScaleFactor: _fontSizeScaleFactor,
          ),
        );
      case PreviewType.meanings:
        return _buildPreviewView(
          child: ItemMeaningsPreviewView(
            item: item,
            fontSize: kItemBodyTextSize * _fontSizeScaleFactor,
          ),
        );
      case PreviewType.examples:
        return _buildPreviewView(
          child: ItemExamplesPreviewView(
            item: item,
            examples: _examples,
            fontScaleFactor: _fontSizeScaleFactor,
          ),
        );
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
            _buildBottomActions(),
          ],
        );
      }),
    );
  }

  _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
            children: [
              const Text('Show Border'),
              Checkbox(
                value: _showBorder,
                onChanged: (value) => setState(() {
                  _showBorder = value;
                }),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: () => _saveImage(),
                icon: const Icon(Icons.image),
                label: const Text('Save Image'),
              ),
              ElevatedButton.icon(
                onPressed: _currentType == PreviewType.full ? _copyText : null,
                icon: const Icon(Icons.abc),
                label: const Text('Copy Text'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabbarView(PreviewType type) {
    final item = widget.item;
    switch (type) {
      case PreviewType.full:
        return ItemFullTextView(item: item);
      case PreviewType.meanings:
        return ItemMeaningsTextView(item: item);
      case PreviewType.examples:
        return ItemExamplesTextView(
          examples: item.examples,
          onExamplesSelected: (examples) {
            setState(() {
              _examples = examples;
            });
          },
        );
    }
  }

  _copyText() async {
    final text = generateFullText(widget.item);
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

  _buildPreviewView({required Widget child}) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        decoration: BoxDecoration(
          color: _showBorder == true ? kBrandColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: child,
              ),
              Positioned.fill(
                right: 16,
                child: Align(
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: 0.05,
                    child: Transform.rotate(
                      angle: -math.pi / 6,
                      child: const EverJapanLogo(
                        lang: LogoLang.zh,
                        logoSize: 80,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
