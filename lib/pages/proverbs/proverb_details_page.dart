import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/pages/proverbs/proverb_display_page.dart';
import 'package:senluo_japanese_cms/repos/proverbs/models/proverb_item.dart';

import '../../common/constants/fonts.dart';
import '../../widgets/sentence_plain_text.dart';
import 'constants/proverb_colors.dart';

class ProverbDetailsPage extends StatelessWidget {
  final ProverbItem proverb;

  const ProverbDetailsPage({super.key, required this.proverb});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ことわざ"),
      ),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              proverb.name,
              style: GoogleFonts.getFont(
                kJpGoogleFont,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: kProverbMainColor,
              ),
            ),
            const _SubTitle('読み方'),
            _Text(proverb.reading),
            const _SubTitle('意味'),
            ...proverb.meanings.map((e) => _Text(e)),
            const _SubTitle('例文'),
            ...proverb.examples.map<SentencePlainText>((e) => SentencePlainText(
                  lines: [e.jp, e.zh],
                  emphasizedColor: kProverbMainColor,
                )),
          ],
        ),
      ),
    );
  }

  _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          OutlinedButton(
            onPressed: () {},
            child: const Text('← 前'),
          ),
          const Gap(16),
          OutlinedButton(
            onPressed: () {},
            child: const Text('次 →'),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => _displayProverb(context),
            icon: const Icon(Icons.image_outlined),
          ),
        ],
      ),
    );
  }

  _displayProverb(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProverbDisplayPage(item: proverb),
      ),
    );
  }
}

class _Text extends StatelessWidget {
  final String text;

  const _Text(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class _SubTitle extends StatelessWidget {
  final String text;

  const _SubTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kProverbMainColor,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
