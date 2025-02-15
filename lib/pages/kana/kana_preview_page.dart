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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildKanaCard(context),
              const Gap(8),
              _buildSubtitle(context, "由来"),
              const Gap(8),
              _buildOrigins(context),
              const Gap(8),
              _buildSubtitle(context, "言葉"),
              const Gap(8),
              _buildRelatedWords(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showStrokeDialog(context),
        child: const FaIcon(FontAwesomeIcons.pen),
      ),
    );
  }

  _showStrokeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("筆順"),
          content: Image.asset("assets/kana/strokes/h0a.gif"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("閉じる"),
            ),
          ],
        );
      },
    );
  }

  Container _buildSubtitle(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  _buildOrigins(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/kana/origins/a-2.png", width: 80),
              Icon(Icons.arrow_right),
              Image.asset("assets/kana/origins/a-1.png", width: 80),
              Icon(Icons.arrow_right),
              Image.asset("assets/kana/origins/a-0.png", width: 80),
            ],
          ),
        ),
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
              RubyText([RubyTextData("青", ruby: 'あお')]),
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
                  kGoogleJPFont,
                  fontSize: 140,
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
