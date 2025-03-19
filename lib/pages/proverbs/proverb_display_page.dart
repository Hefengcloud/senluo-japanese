import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_common/widgets/everjapan_watermark.dart';
import 'package:senluo_japanese_cms/pages/proverbs/constants/proverb_colors.dart';
import 'package:senluo_japanese_cms/pages/proverbs/helpers/proverb_text_helper.dart';
import 'package:senluo_japanese_cms/repos/proverbs/models/proverb_item.dart';

import '../../common/helpers/image_helper.dart';

class ProverbDisplayPage extends StatefulWidget {
  final ProverbItem item;

  const ProverbDisplayPage({super.key, required this.item});

  @override
  State<ProverbDisplayPage> createState() => _ProverbDisplayPageState();
}

class _ProverbDisplayPageState extends State<ProverbDisplayPage> {
  final GlobalKey globalKey = GlobalKey();

  double _currentSliderValue = 72;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
      ),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomAppBar(context, widget.item),
    );
  }

  _buildBottomAppBar(BuildContext context, ProverbItem item) {
    return BottomAppBar(
      child: Row(
        children: [
          Expanded(
            child: _buildFontSlider(),
          ),
          IconButton(
            onPressed: () => _copyText(item),
            icon: const Icon(Icons.copy_outlined),
          ),
          IconButton(
            onPressed: () => _saveProverbAsImage(item),
            icon: const Icon(Icons.save_outlined),
          ),
        ],
      ),
    );
  }

  RepaintBoundary _buildBody(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
          color: kProverbBgColor,
          padding: const EdgeInsets.all(8.0),
          child: EverjapanWatermark(
            child: _buildImageContent(context, widget.item),
          ),
        ),
      ),
    );
  }

  _buildFontSlider() => Row(
        children: [
          const Text('Font:'),
          Expanded(
            child: Slider(
              value: _currentSliderValue,
              min: 48,
              max: 88,
              label: _currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),
          ),
        ],
      );

  _buildImageContent(BuildContext context, ProverbItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const _ProverbLabel(),
          const Spacer(),
          _ProverbReadingView(item: item),
          _buildIllustration(context, item),
          const Spacer(),
          ...item.meanings.map<AutoSizeText>(
            (e) => AutoSizeText(
              e,
              textAlign: TextAlign.center,
              style: GoogleFonts.maShanZheng(
                textStyle: const TextStyle(fontSize: 24.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildIllustration(BuildContext context, ProverbItem item) {
    if (item.imgUrl?.isNotEmpty == true) {
      return Image.network(item.imgUrl!);
    }
    return AutoSizeText(
      item.name,
      textAlign: TextAlign.center,
      style: GoogleFonts.notoSansJp(
        fontSize: _currentSliderValue,
        fontWeight: FontWeight.bold,
        color: kProverbMainColor,
      ),
    );
  }

  _saveProverbAsImage(ProverbItem item) async {
    final bytes = await captureWidget(globalKey);
    if (Platform.isIOS || Platform.isAndroid) {
      await saveImageToGallery(bytes!);
    } else {
      await saveImageToFile(bytes!, '${item.name}.png');
    }
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image Saved'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  _copyText(ProverbItem item) async {
    final text = generateProverbText(item);
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Text Copyied!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _ProverbReadingView extends StatelessWidget {
  final ProverbItem item;

  const _ProverbReadingView({required this.item});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      item.reading,
      textAlign: TextAlign.center,
      style: GoogleFonts.notoSansJp(
        textStyle: const TextStyle(fontSize: 28),
      ),
      maxLines: 1,
    );
  }
}

class _ProverbLabel extends StatelessWidget {
  const _ProverbLabel();

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        'ことわざ',
        style: GoogleFonts.notoSansJp(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: kProverbMainColor,
      shape: const StadiumBorder(
        side: BorderSide(style: BorderStyle.none),
      ),
    );
  }
}
