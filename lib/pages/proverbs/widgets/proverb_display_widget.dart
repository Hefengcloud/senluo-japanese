import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/constants/colors.dart';
import 'package:senluo_japanese_cms/repos/proverbs/models/proverb_item.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_logo.dart';

import '../../../helpers/image_helper.dart';

class ProverbDisplayWidget extends StatelessWidget {
  final GlobalKey globalKey = GlobalKey();

  final ProverbItem item;

  ProverbDisplayWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: RepaintBoundary(
            key: globalKey,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Card(
                color: const Color.fromRGBO(0xF2, 0xE9, 0xE1, 1),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildContent(context),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildText(),
          ),
        ),
      ],
    );
  }

  Column _buildText() {
    final proverbText = _generateDisplayText(item);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          '日语谚语 | ${item.name}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(16),
        SelectableText(
          proverbText,
          style: const TextStyle(fontSize: 20),
        ),
        Row(
          children: [
            OutlinedButton(
              onPressed: () => _saveProverbAsImage(),
              child: const Text('Save Image'),
            ),
            const Gap(8),
            OutlinedButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: proverbText));
              },
              child: const Text('Copy Text'),
            ),
          ],
        ),
      ],
    );
  }

  String _generateDisplayText(ProverbItem item) {
    return """
🔈【读音】
${item.reading}

💡【意思】
${item.meanings.map((e) => '- $e').toList().join('\n')}

✍️【例句】
${item.examples.map((e) => "◎ ${e.jp}\n→ ${e.zh}").toList().join('\n')}
""";
  }

  Column _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Gap(32),
        AutoSizeText(
          item.name,
          textAlign: TextAlign.center,
          style: GoogleFonts.getFont(
            'Yusei Magic',
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
            'Yusei Magic',
            textStyle: const TextStyle(
              fontSize: 32,
              color: Colors.black54,
            ),
          ),
          maxLines: 1,
        ),
        const Gap(16),
        Expanded(
          child: Center(
            child: _buildIllustration(context, item),
          ),
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
    );
  }

  _buildIllustration(BuildContext context, ProverbItem item) {
    if (item.imgUrl?.isNotEmpty == true) {
      return Image.network(item.imgUrl!);
    }
    return AutoSizeText(
      item.name,
      textAlign: TextAlign.center,
      style: GoogleFonts.getFont(
        'Rampart One',
        fontSize: 96,
      ),
    );
  }

  _saveProverbAsImage() async {
    final bytes = await captureWidget(globalKey);
    await saveImageToFile(bytes!, 'proverb.png');
  }
}
