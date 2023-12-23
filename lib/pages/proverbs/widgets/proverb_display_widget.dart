import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:senluo_japanese_cms/constants/colors.dart';
import 'package:senluo_japanese_cms/repos/proverbs/models/proverb_item.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_logo.dart';

class ProverbDisplayWidget extends StatelessWidget {
  final ProverbItem item;
  const ProverbDisplayWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Card(
        color: const Color.fromRGBO(0xF2, 0xE9, 0xE1, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(32),
              AutoSizeText(
                item.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  'Rampart One',
                  textStyle: const TextStyle(
                    fontSize: 48,
                    color: kColorBrand,
                  ),
                ),
                maxLines: 1,
              ),
              AutoSizeText(
                item.reading,
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  'Zen Kurenaido',
                  textStyle: const TextStyle(
                    fontSize: 24,
                    color: Colors.black54,
                  ),
                ),
                maxLines: 1,
              ),
              const Gap(16),
              Expanded(
                child: Image.network(
                    'https://nihongokyoshi-net.com/wp-content/uploads/2021/01/amatamakushite.png'),
              ),
              const Gap(16),
              ...item.meanings
                  .map<AutoSizeText>(
                    (e) => AutoSizeText(
                      e,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont(
                        'ZCOOL KuaiLe',
                        textStyle: const TextStyle(fontSize: 32.0),
                      ),
                    ),
                  )
                  .toList(),
              const Gap(32),
              const Opacity(
                opacity: 0.8,
                child: EverJapanLogo(),
              ),
              const Gap(8),
            ],
          ),
        ),
      ),
    );
  }
}
