import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/constants/colors.dart';
import 'package:senluo_japanese_cms/repos/proverbs/models/proverb_item.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_logo.dart';

import '../../../constants/texts.dart';
import '../../../helpers/image_helper.dart';

class ProverbDisplayWidget extends StatefulWidget {
  final ProverbItem item;

  const ProverbDisplayWidget({super.key, required this.item});

  @override
  State<ProverbDisplayWidget> createState() => _ProverbDisplayWidgetState();
}

class _ProverbDisplayWidgetState extends State<ProverbDisplayWidget> {
  final GlobalKey globalKey = GlobalKey();

  double _currentSliderValue = 96;

  @override
  Widget build(BuildContext context) {
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
                color: kBgColor,
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
            child: _buildText(context),
          ),
        ),
      ],
    );
  }

  Column _buildText(BuildContext context) {
    final proverbText = _generateDisplayText(widget.item);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(8),
        SelectableText(
          proverbText,
          style: const TextStyle(fontSize: 18),
        ),
        const Divider(),
        _buildSlider(),
        const Gap(8),
        Row(
          children: [
            OutlinedButton(
              onPressed: () => _saveProverbAsImage(),
              child: const Text('Save Image'),
            ),
            const Gap(8),
            OutlinedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: proverbText));
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Copied')));
              },
              child: const Text('Copy Text'),
            ),
          ],
        ),
      ],
    );
  }

  _buildSlider() => Row(
        children: [
          Text('Font Size:'),
          Expanded(
            child: Slider(
              value: _currentSliderValue,
              min: 64,
              max: 112,
              divisions: 6,
              label: _currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),
          ),
        ],
      );

  String _generateDisplayText(ProverbItem item) {
    return """
日语谚语 | ${item.name}

🔈【读音】
${item.reading}

💡【意思】
${item.meanings.map((e) => '・ $e').toList().join('\n')}

$kTitleExample
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
          widget.item.name,
          textAlign: TextAlign.center,
          style: GoogleFonts.getFont(
            'Yusei Magic',
            textStyle: const TextStyle(
              fontSize: 48,
              color: kBrandColor,
            ),
          ),
          maxLines: 1,
        ),
        AutoSizeText(
          widget.item.reading,
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
            child: _buildIllustration(context, widget.item),
          ),
        ),
        const Gap(16),
        ...widget.item.meanings
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
        fontSize: _currentSliderValue,
        color: kBrandColor,
      ),
    );
  }

  _saveProverbAsImage() async {
    final bytes = await captureWidget(globalKey);
    await saveImageToFile(bytes!, 'proverb.png');
  }
}
