import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/common/enums/enums.dart';
import 'package:senluo_japanese_cms/constants/colors.dart';
import 'package:senluo_japanese_cms/helpers/image_helper.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/constants/contants.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_concise_preview_view.dart';
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

enum PreviewMode {
  single,
  multiple,
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
  DistributionChannel _channel = DistributionChannel.none;
  PreviewMode? _mode = PreviewMode.single;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: RepaintBoundary(
            key: globalKey,
            child: AspectRatio(
              aspectRatio: _channel.aspectRatio,
              child: _mode == PreviewMode.single
                  ? _buildSingleLeft(context)
                  : _buildMultiLeft(context),
            ),
          ),
        ),
        Expanded(flex: 2, child: _buildRight(context)),
      ],
    );
  }

  _buildSingleLeft(BuildContext context) {
    return _buildPreviewView(
      child: ItemConcisePreviewView(
        item: widget.item,
        examples: _examples,
        fontScaleFactor: _fontSizeScaleFactor,
      ),
    );
  }

  _buildMultiLeft(BuildContext context) {
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
          const Divider(),
          _buildFontModifier(),
          Row(
            children: [
              const Text('Mode: '),
              _buildPreviewModeOptions(context),
              const Gap(16),
              const Text('Channel: '),
              _buildDistributionChannelOptions(context),
            ],
          ),
          const Gap(16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _saveImage(),
                icon: const Icon(Icons.image),
                label: const Text('Save Image'),
              ),
              const Gap(8),
              ElevatedButton.icon(
                onPressed: _currentType == PreviewType.full ? _copyText : null,
                icon: const Icon(Icons.copy),
                label: const Text('Copy Text'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row _buildFontModifier() {
    return Row(
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
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copyied'),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
    return Container(
      decoration: BoxDecoration(
        color: kChannel2Color[_channel],
      ),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kItemBgColor,
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
    );
  }

  _buildDistributionChannelOptions(BuildContext context) =>
      DropdownButton<DistributionChannel>(
        value: _channel,
        onChanged: (DistributionChannel? value) {
          // This is called when the user selects an item.
          setState(() {
            _channel = value!;
          });
        },
        items: DistributionChannel.values
            .map<DropdownMenuItem<DistributionChannel>>(
                (DistributionChannel value) {
          return DropdownMenuItem<DistributionChannel>(
            value: value,
            child: Text(value.text),
          );
        }).toList(),
      );

  _buildPreviewModeOptions(BuildContext context) => DropdownButton<PreviewMode>(
        value: _mode,
        onChanged: (PreviewMode? value) {
          // This is called when the user selects an item.
          setState(() {
            _mode = value!;
          });
        },
        items: PreviewMode.values
            .map<DropdownMenuItem<PreviewMode>>((PreviewMode value) {
          return DropdownMenuItem<PreviewMode>(
            value: value,
            child: Text(value.name),
          );
        }).toList(),
      );
}
