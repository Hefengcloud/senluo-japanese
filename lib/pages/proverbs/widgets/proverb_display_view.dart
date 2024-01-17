import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/common/constants/number_constants.dart';
import 'package:senluo_japanese_cms/repos/proverbs/models/proverb_item.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_logo.dart';

import '../../../constants/texts.dart';
import '../../../helpers/image_helper.dart';

const _kBgColor = Color(0xFFEFE8D6);
const _kMainColor = Color(0xFFBD1723);

class ProverbDisplayView extends StatefulWidget {
  final ProverbItem item;

  const ProverbDisplayView({super.key, required this.item});

  @override
  State<ProverbDisplayView> createState() => _ProverbDisplayViewState();
}

class _ProverbDisplayViewState extends State<ProverbDisplayView> {
  final GlobalKey globalKey = GlobalKey();

  double _currentSliderValue = 96;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: kPreviewLeftFlex,
          child: RepaintBoundary(
            key: globalKey,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Card(
                color: _kBgColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildContent(context),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: kPreviewRightFlex,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                _buildRightPanel(context),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: _buildBottomActions(
                      context,
                      _generateDisplayText(widget.item),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildRightPanel(BuildContext context) {
    final proverbText = _generateDisplayText(widget.item);
    return ListView(
      children: [
        SelectableText(
          proverbText,
          style: const TextStyle(fontSize: 18),
        ),
        // _buildBottomActions(context, proverbText),
      ],
    );
  }

  _buildBottomActions(BuildContext context, String proverbText) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          const Gap(8),
          _buildSlider(),
          const Gap(8),
          Row(
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.image),
                onPressed: () => _saveProverbAsImage(),
                label: const Text('Save Image'),
              ),
              const Gap(8),
              OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: proverbText));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copyied'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy Text'),
              ),
            ],
          ),
        ],
      );

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
    String text = """
日语谚语 | ${item.name}

🔈【读音】
${item.reading}

💡【意思】
${item.meanings.map((e) => '・ $e').toList().join('\n')}
""";

    if (item.examples.isNotEmpty) {
      text += """

$kTitleExample
${item.examples.map((e) => "◎ ${e.jp}\n→ ${e.zh}").toList().join('\n')}
""";
    }
    return text;
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
            'Shippori Mincho B1',
            textStyle: const TextStyle(
              fontSize: 48,
              color: _kMainColor,
            ),
          ),
          maxLines: 1,
        ),
        AutoSizeText(
          widget.item.reading,
          textAlign: TextAlign.center,
          style: GoogleFonts.getFont(
            'Shippori Mincho B1',
            textStyle: const TextStyle(fontSize: 32),
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
                  'Ma Shan Zheng',
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
        color: _kMainColor,
      ),
    );
  }

  _saveProverbAsImage() async {
    final bytes = await captureWidget(globalKey);
    await saveImageToFile(bytes!, '${widget.item.name}.png');
  }
}
