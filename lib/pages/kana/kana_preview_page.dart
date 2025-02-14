import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ruby_text/ruby_text.dart';
import 'package:senluo_japanese_cms/common/constants/fonts.dart';

import '../../repos/gojuon/models/models.dart';

class KanaPreviewPage extends StatelessWidget {
  final Kana kana;
  const KanaPreviewPage({super.key, required this.kana});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kana.hiragana),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildKanaCard(context),
            const Gap(16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("「${kana.hiragana}」を含む言葉："),
            ),
            _buildRelatedWords(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const FaIcon(FontAwesomeIcons.pen),
      ),
    );
  }

  _buildRelatedWords(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RubyText([RubyTextData("愛", ruby: 'あい')]),
              RubyText([RubyTextData("青", ruby: 'あお')]),
              RubyText([RubyTextData("甘", ruby: 'あま'), RubyTextData("い")]),
            ],
          ),
        ),
      ),
    );
  }

  _buildKanaCard(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: InkWell(
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AutoSizeText(
                kana.hiragana,
                style: GoogleFonts.getFont(
                  kJpGoogleFont,
                  fontSize: 160,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(16),
              const FaIcon(FontAwesomeIcons.volumeHigh),
              const Gap(8),
              Text(kana.romaji, style: const TextStyle(fontSize: 18)),
              const Gap(32),
            ],
          ),
        ),
      ),
    );
  }
}
