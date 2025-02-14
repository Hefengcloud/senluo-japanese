import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senluo_japanese_cms/common/helpers/image_helper.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/onomatopoeia_image_view.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';

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

class OnomatopoeiaPreviewPage extends StatefulWidget {
  final Onomatopoeia item;

  const OnomatopoeiaPreviewPage({super.key, required this.item});

  @override
  State<OnomatopoeiaPreviewPage> createState() =>
      _OnomatopoeiaPreviewPageState();
}

class _OnomatopoeiaPreviewPageState extends State<OnomatopoeiaPreviewPage> {
  final GlobalKey _globalKey = GlobalKey();

  double _fontSizeScaleFactor = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
      ),
      body: _buildImage(context),
      endDrawer: _buildDrawer(context),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          _buildFontModifier(),
        ],
      ),
    );
  }

  _buildImage(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: OnomatopoeiaImageView(
          item: widget.item,
          examples: widget.item.examples,
        ),
      ),
    );
  }

  _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [],
      ),
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
    final bytes = await captureWidget(_globalKey);
    if (bytes != null) {
      final fileName = widget.item.key;
      await saveImageToFile(
        bytes,
        '$fileName.jpg',
      );
    }
  }
}
