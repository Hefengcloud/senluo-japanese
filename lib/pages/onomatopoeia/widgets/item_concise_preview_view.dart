import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/constants/colors.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';

import '../../../widgets/example_sentence_text.dart';

class ItemConcisePreviewView extends StatelessWidget {
  final Onomatopoeia item;
  final List<Example> examples;
  final double fontScaleFactor;

  static const _kJpGoogleFont = 'Zen Maru Gothic';
  static const _kZhFont = 'JiYingHuiPianHeYuan';
  static const _kBodyFontSize = 18.0;

  const ItemConcisePreviewView({
    super.key,
    required this.item,
    required this.examples,
    this.fontScaleFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        children: [
          const Gap(32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AutoSizeText(
                  item.name.split('/').map<String>((e) => e.trim()).join('\n'),
                  style: GoogleFonts.getFont(
                    _kJpGoogleFont,
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: kItemMainColor,
                  ),
                  maxLines: item.name.split('/').length,
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                width: 160,
                height: 160,
                child: Image.asset(
                  'assets/onomatopoeia/images/${item.key}.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          const Gap(32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle('意思'),
              const Gap(16),
              Flexible(
                child: Text(
                  item.meanings['zh']!.join('；'),
                  style: TextStyle(
                    fontFamily: _kZhFont,
                    fontSize: _kBodyFontSize * fontScaleFactor,
                  ),
                ),
              ),
            ],
          ),
          const Gap(32),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _buildTitle('例句'),
                ),
                const Gap(16),
                Expanded(
                  child: ListView(
                    children: (examples.isNotEmpty
                            ? examples
                            : item.examples.take(2).toList())
                        .map<Widget>((e) => _buildExamples(e))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamples(Example example) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: ExampleSentenceText(
        lines: [example['jp']!],
        mainStyle: GoogleFonts.getFont(
          _kJpGoogleFont,
          fontSize: _kBodyFontSize * fontScaleFactor,
          fontWeight: FontWeight.bold,
        ),
        emphasizedColor: kItemMainColor,
      ),
      subtitle: Text(
        example['zh']!,
        style: TextStyle(
          fontFamily: _kZhFont,
          fontSize: _kBodyFontSize * fontScaleFactor - 2,
          color: Colors.black54,
        ),
      ),
    );
  }

  _buildTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: _kZhFont,
        color: kItemMainColor,
        fontSize: _kBodyFontSize * fontScaleFactor,
      ),
    );
  }
}
