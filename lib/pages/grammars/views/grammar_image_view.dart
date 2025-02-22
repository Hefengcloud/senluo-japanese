import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_logo.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_watermark.dart';
import 'package:senluo_japanese_cms/widgets/japanese_sentence.dart';

import '../../../common/constants/colors.dart';
import 'grammar_conjugation_text.dart';

class GrammarImageView extends StatefulWidget {
  final GrammarItem item;

  final double fontScale;

  const GrammarImageView({
    super.key,
    required this.item,
    this.fontScale = 1.0,
  });

  @override
  State<GrammarImageView> createState() => _GrammarImageViewState();
}

class _GrammarImageViewState extends State<GrammarImageView> {
  double _spacing = 10.0; // Initial spacing between items

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: _updateSpacing,
      child: Container(
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
              _buildTopLogo(widget.item),
              const Gap(8),
              _buildItemName(widget.item.name, widget.item.level),
              const Gap(16),
              _buildJpMeaning(widget.item),
              const Gap(8),
              _buildZhMeaning(widget.item),
              const Gap(16),
              _buildConjugation(widget.item),
              _buildDivider(context),
              Expanded(child: _buildExampleList(widget.item)),
            ],
          ),
        ),
      ),
    );
  }

  void _updateSpacing(DragUpdateDetails details) {
    setState(() {
      // Adjust spacing based on vertical drag delta
      _spacing += details.delta.dy / 10;
      // Clamp the spacing to avoid negative or extreme values
      _spacing = _spacing.clamp(0.0, 32.0);
    });
  }

  _buildDivider(BuildContext context) => Container(
        width: 48,
        margin: EdgeInsets.only(
          top: 8 + _spacing,
          bottom: _spacing,
        ),
        child: const Divider(
          height: 0.5,
          color: Colors.black12,
        ),
      );

  Widget _buildZhMeaning(GrammarItem item) {
    return AutoSizeText(
      item.meaning.zhs.join(' / '),
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
        fontSize: (60 - (nameParts.length - 1) * 8) * widget.fontScale,
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
        children: item.conjugations
            .map((e) => GrammarConjugationText(
                  text: e,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontVariations: [FontVariation.weight(700)],
                  ),
                ))
            .toList(),
      ),
    );
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
          .map((e) => JapaneseSentence(
                japanese: e.jp1.isNotEmpty ? e.jp1 : e.jp,
                translation: e.zh,
                emphasizedColor: kLevel2color[item.level]!,
                fontSize: 14 * widget.fontScale,
                prefix: '',
              ))
          .toList(),
    );
  }
}
