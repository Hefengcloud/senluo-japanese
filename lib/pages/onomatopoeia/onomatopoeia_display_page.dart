import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/common/constants/number_constants.dart';
import 'package:senluo_japanese_cms/common/enums/enums.dart';
import 'package:senluo_japanese_cms/common/constants/colors.dart';
import 'package:senluo_japanese_cms/common/helpers/image_helper.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/previews/item_concise_preview_view.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/previews/item_examples_preview_view.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_examples_text_view.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/previews/item_full_preview_view.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_full_text_view.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/previews/item_meanings_preview_view.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_meanings_text_view.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_watermark.dart';

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
  final GlobalKey _globalKey = GlobalKey();

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
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(child: _buildContent(context)),
        const Gap(16),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.image_outlined),
              onPressed: () => _saveImage(),
            ),
            IconButton(
              icon: const Icon(Icons.abc_outlined),
              onPressed: _currentType == PreviewType.full ? _copyText : null,
            ),
            const Gap(16),
            _buildPreviewModeOptions(context),
            const Gap(16),
            _buildDistributionChannelOptions(context),
            const Gap(16),
            _buildFontModifier(),
          ],
        ),
      ],
    );
  }

  Row _buildContent(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: kPreviewLeftFlex,
          child: RepaintBoundary(
            key: _globalKey,
            child: AspectRatio(
              aspectRatio: _channel.aspectRatio,
              child: _mode == PreviewMode.single
                  ? _buildSingleLeft(context)
                  : _buildMultiLeft(context),
            ),
          ),
        ),
        Expanded(
          flex: kPreviewRightFlex,
          child: _buildRight(context),
        ),
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
            fontSizeScaleFactor: _fontSizeScaleFactor,
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
          ],
        );
      }),
    );
  }

  _buildFontModifier() {
    return DropdownButton<double>(
      value: _fontSizeScaleFactor,
      items: [0.8, 0.9, 1.0, 1.1, 1.2]
          .map<DropdownMenuItem<double>>((e) => DropdownMenuItem(
                value: e,
                child: Text("Font Scale: ${e.toString()}"),
              ))
          .toList(),
      onChanged: (value) => setState(() {
        _fontSizeScaleFactor = value!;
      }),
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
    final text = _mode == PreviewMode.single
        ? generateChineseText(widget.item)
        : generateFullText(widget.item);
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
    final bytes = await captureWidget(_globalKey);
    if (bytes != null) {
      final fileName = _mode == PreviewMode.single
          ? widget.item.key
          : '${widget.item.key}-${_currentType.value.toLowerCase()}';
      await saveImageToFile(
        bytes,
        '$fileName.jpg',
      );
    }
  }

  _buildPreviewView({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: _channel == DistributionChannel.zhiHu
            ? Colors.white
            : kChannel2Color[_channel],
      ),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _channel == DistributionChannel.zhiHu
              ? Colors.white
              : kItemBgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: EverjapanWatermark(child: child),
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
            child: Text("Channel: ${value.text}"),
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
            child: Text("Mode: ${value.name}"),
          );
        }).toList(),
      );
}
