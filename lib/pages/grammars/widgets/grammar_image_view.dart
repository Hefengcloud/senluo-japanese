import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_logo.dart';
import 'package:senluo_japanese_cms/widgets/sentence_text.dart';

import '../../../constants/colors.dart';
import '../constants/colors.dart';

class GrammarImageView extends StatelessWidget {
  GrammarImageView({
    super.key,
    required this.item,
  });

  final GlobalKey globalKey = GlobalKey();

  final GrammarItem item;

  @override
  Widget build(BuildContext context) {
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
              _buildTop(),
              const Gap(32),
              AutoSizeText(
                item.name,
                maxLines: 1,
                style: GoogleFonts.getFont(
                  'Rampart One',
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: kColorN1,
                ),
              ),
              const Gap(8),
              AutoSizeText(
                item.meaning.jp.join('、'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: kColorBrand,
                ),
                maxLines: 1,
              ),
              const Gap(32),
              Text(
                item.meaning.cn.join('、'),
                style: const TextStyle(
                  color: kColorN1,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
              const Gap(32),
              _buildConjugation(),
              const Gap(32),
              const Divider(
                height: 0.5,
                color: Colors.black12,
              ),
              const Gap(32),
              ..._buildExamples(item.examples),
            ],
          ),
        ),
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
        color: kColorN1,
      ),
      child: Text(
        item.conjugations.join('\n'),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
    );
  }

  _buildTop() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        EverJapanLogo(),
        Chip(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: kColorN1),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          label: Text(
            'JLPT N1',
            style: TextStyle(color: kColorN1),
          ),
        ),
      ],
    );
  }

  _buildExamples(List<GrammarExample> examples) {
    return examples
        .take(3)
        .map((e) => Padding(
              padding: const EdgeInsets.only(
                bottom: 32.0,
              ),
              child: SentenceText(
                lines: [e.jp, e.cn],
                emphasizedColor: kColorN1,
              ),
            ))
        .toList();
  }

  Future<Uint8List?> captureWidget() async {
    final boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}
