import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/pages/jlpt/constants/colors.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_logo.dart';
import 'package:senluo_japanese_cms/widgets/sentence_text.dart';

import '../../../constants/colors.dart';

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
              _buildTop(),
              const Gap(32),
              AutoSizeText(
                item.name,
                maxLines: 1,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: kColorN1,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Gap(8),
              AutoSizeText(
                item.meaning.jp.join('；'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: kColorBrand,
                ),
                maxLines: 1,
              ),
              const Gap(32),
              Text(
                item.meaning.cn.join('；'),
                style: const TextStyle(color: kColorN1, fontSize: 20.0),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
              const Gap(32),
              Container(
                color: kColorN1,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                  item.conjugations.join('\n'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                ),
              ),
              const Gap(32),
              ..._buildExamples(item.examples),
            ],
          ),
        ),
      ),
    );
  }

  _buildTop() {
    return Row(
      children: [
        const EverJapanLogo(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 4.0,
          ),
          color: kColorN1,
          child: const Text(
            'JLPT N1',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  _buildExamples(List<GrammarExample> examples) {
    return examples
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

  _buildTitle(String text) => Padding(
        padding: const EdgeInsets.only(
          bottom: 4,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black54),
        ),
      );

  Future<Uint8List?> captureWidget() async {
    final boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}
