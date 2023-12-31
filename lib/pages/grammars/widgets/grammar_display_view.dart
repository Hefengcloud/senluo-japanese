import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/pages/grammars/helpers/grammar_helper.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_logo.dart';
import 'package:senluo_japanese_cms/widgets/sentence_text.dart';

import '../../../constants/colors.dart';
import '../../../helpers/image_helper.dart';
import '../constants/colors.dart';

class GrammarDisplayView extends StatelessWidget {
  GrammarDisplayView({
    super.key,
    required this.item,
    this.examples = const [],
  }) {
    _mainColor = kLevel2color[item.level]!;
  }

  final GlobalKey globalKey = GlobalKey();

  final GrammarItem item;
  final List<GrammarExample> examples;
  late final Color _mainColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _buildImage(),
        ),
        const Gap(16),
        Expanded(
          flex: 2,
          child: Stack(
            children: [
              SelectableText(item.text),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildBottomButtons(context),
                ),
              ),
            ],
          ),
          // child: SingleChildScrollView(
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [

          //
          //     ],
          //   ),
          // ),
        ),
      ],
    );
  }

  _buildBottomButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton.icon(
          onPressed: () => _onSaveImage(),
          icon: const Icon(Icons.save),
          label: const Text('Save Image'),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.abc),
          label: const Text('Copy Text'),
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: item.text));
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Copied')));
          },
        )
      ],
    );
  }

  RepaintBoundary _buildImage() {
    final itemNameParts = _parseItemName(item.name);
    final itemName = itemNameParts[0];
    final itemReading = itemNameParts.length > 1 ? itemNameParts[1] : null;

    return RepaintBoundary(
      key: globalKey,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/grammar-bg.png'),
              fit: BoxFit.cover,
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const Gap(16),
              _buildTopLogo(),
              const Gap(16),
              _buildItemName(itemName),
              if (itemReading != null) _buildItemReading(itemReading),
              const Gap(8),
              _buildJpMeaning(),
              const Gap(32),
              _buildZhMeaning(),
              const Gap(32),
              _buildConjugation(),
              const Gap(32),
              const Divider(
                height: 0.5,
                color: Colors.black12,
              ),
              const Gap(32),
              ..._buildExamples(),
            ],
          ),
        ),
      ),
    );
  }

  Text _buildZhMeaning() {
    return Text(
      item.meaning.cn.join('；'),
      style: TextStyle(
        color: _mainColor,
        fontSize: 24.0,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
    );
  }

  AutoSizeText _buildJpMeaning() {
    return AutoSizeText(
      item.meaning.jp.join('；'),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 24,
        color: kBrandColor,
      ),
      maxLines: 1,
    );
  }

  AutoSizeText _buildItemName(String itemName) {
    return AutoSizeText(
      itemName,
      maxLines: 1,
      style: GoogleFonts.getFont(
        'Rampart One',
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: _mainColor,
      ),
    );
  }

  _buildItemReading(String itemReading) {
    return Text(
      "$itemReading",
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 20,
      ),
    );
  }

  Container _buildConjugation() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: _mainColor,
      ),
      child: Text(
        item.conjugations.join('\n'),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
        ),
      ),
    );
  }

  _buildTopLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const EverJapanLogo(),
        Chip(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: _mainColor),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          label: Text(
            'JLPT ${item.level.toUpperCase()}',
            style: TextStyle(color: _mainColor),
          ),
        ),
      ],
    );
  }

  _buildExamples() {
    final theExamples = examples.isNotEmpty ? examples : item.examples.take(2);
    return theExamples
        .map((e) => Padding(
              padding: const EdgeInsets.only(
                bottom: 0.0,
              ),
              child: SentenceText(
                fontSize: 24.0,
                lines: [e.jp, e.cn],
                emphasizedColor: _mainColor,
                textAlign: TextAlign.left,
                multipleLines: false,
              ),
            ))
        .toList();
  }

  _onSaveImage() async {
    final bytes = await captureWidget(globalKey);
    saveImageToFile(bytes!, 'grammar.jpg');
  }

  List<String> _parseItemName(String itemName) {
    RegExp regex = RegExp(r'（([^（）]+)）');
    Match? match = regex.firstMatch(item.name);
    final String itemName = item.name.replaceAll(regex, '');
    if (match != null) {
      return [itemName, match.group(1)!];
    } else {
      return [itemName];
    }
  }
}
