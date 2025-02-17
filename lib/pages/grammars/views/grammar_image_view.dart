import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_logo.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_watermark.dart';

import '../../../common/constants/colors.dart';
import '../../../widgets/sentence_html_text.dart';

class GrammarImageView extends StatelessWidget {
  final GrammarItem item;

  final double dividerGap;
  final double exampleFontSize;

  const GrammarImageView({
    super.key,
    required this.item,
    required this.dividerGap,
    required this.exampleFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/grammar-bg.png'),
          fit: BoxFit.cover,
        ),
        color: Colors.white,
      ),
      child: EverjapanWatermark(
        child: Column(
          children: [
            _buildTopLogo(item),
            const Gap(8),
            _buildItemName(item.name, item.level),
            const Gap(16),
            _buildJpMeaning(item),
            const Gap(8),
            _buildZhMeaning(item),
            const Gap(16),
            _buildConjugation(item),
            _buildDivider(context),
            Expanded(child: _buildExampleList(item)),
          ],
        ),
      ),
    );
  }

  _buildDivider(BuildContext context) => Container(
        width: 48,
        margin: EdgeInsets.only(
          top: 8 + dividerGap,
          bottom: dividerGap,
        ),
        child: const Divider(
          height: 0.5,
          color: Colors.black12,
        ),
      );

  Widget _buildZhMeaning(GrammarItem item) {
    return AutoSizeText(
      item.meaning.zhs.join(' '),
      style: TextStyle(
        color: kLevel2color[item.level],
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
    );
  }

  AutoSizeText _buildJpMeaning(GrammarItem item) {
    return AutoSizeText(
      item.meaning.jps.join(''),
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: kBrandColor,
      ),
    );
  }

  AutoSizeText _buildItemName(String itemName, JLPTLevel level) {
    final nameParts = itemName.split('/').map((e) => e.trim()).toList();
    return AutoSizeText(
      nameParts.join('\n'),
      maxLines: nameParts.length,
      style: GoogleFonts.kleeOne(
        fontSize: 60 - (nameParts.length - 1) * 8,
        fontWeight: FontWeight.bold,
        color: kLevel2color[level],
      ),
    );
  }

  Container _buildConjugation(GrammarItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: kLevel2color[item.level]!.withValues(alpha: .9),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children:
            item.conjugations.map((e) => _buildConjugationText(e)).toList(),
      ),
    );
  }

  Widget _buildConjugationText(String text) {
    RegExp pattern = RegExp(r'(.*?)(~~.*?~~)(.*)');
    Match? match = pattern.firstMatch(text);
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontVariations: [FontVariation.weight(700)],
    );

    if (match != null) {
      String textBefore = match.group(1) ?? "";
      String textDeleted = match.group(2) ?? "";
      String textAfter = match.group(3) ?? "";
      return Text.rich(
        TextSpan(children: [
          TextSpan(text: textBefore, style: style),
          TextSpan(
            text: textDeleted.replaceAll('~', ''),
            style: style.copyWith(
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.white,
              decorationThickness: 2,
            ),
          ),
          TextSpan(text: textAfter, style: style),
        ]),
      );
    } else {
      return Text(text, style: style);
    }
  }

  _buildTopLogo(GrammarItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            color: kLevel2color[item.level],
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            'JLPT ${item.level.name.toUpperCase()}',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const EverJapanLogo(),
      ],
    );
  }

  _buildExampleList(GrammarItem item) {
    return Column(
      children: item.examples
          .map((e) => SentenceHtmlText(
                original: e.jp,
                formated: e.jp1,
                translated: e.zh,
                emphasizedColor: kLevel2color[item.level]!,
                fontSize: exampleFontSize,
              ))
          .toList(),
    );
  }
}
