import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/common/constants/number_constants.dart';
import 'package:senluo_japanese_cms/pages/proverbs/bloc/proverb_bloc.dart';
import 'package:senluo_japanese_cms/repos/proverbs/models/proverb_item.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_logo.dart';
import 'package:senluo_japanese_cms/widgets/everjapan_watermark.dart';

import '../../../constants/texts.dart';
import '../../../helpers/image_helper.dart';

const _kBgColor = Color(0xFFEFE8D6);
const _kMainColor = Color(0xFFBD1723);

class ProverbDisplayView extends StatefulWidget {
  const ProverbDisplayView({super.key});

  @override
  State<ProverbDisplayView> createState() => _ProverbDisplayViewState();
}

class _ProverbDisplayViewState extends State<ProverbDisplayView> {
  final GlobalKey globalKey = GlobalKey();

  double _currentSliderValue = 72;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProverbBloc, ProverbState>(
      builder: (context, state) {
        if (state is ProverbLoaded) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: _buildContent(context, state.currentItem)),
              const Gap(16),
              _buildTheBottomActions(context, state.currentItem),
            ],
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  _buildTheBottomActions(BuildContext context, ProverbItem item) {
    final bloc = BlocProvider.of<ProverbBloc>(context);
    return Row(
      children: [
        IconButton(
          onPressed: () => bloc.add(const ProverbChanged(next: false)),
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        IconButton(
          onPressed: () => bloc.add(const ProverbChanged(next: true)),
          icon: const Icon(Icons.arrow_forward_outlined),
        ),
        IconButton(
          onPressed: () => _saveProverbAsImage(item),
          icon: const Icon(Icons.image_outlined),
        ),
        IconButton(
          onPressed: () => _copyText(item),
          icon: const Icon(Icons.abc_outlined),
        ),
        const Gap(16),
        SizedBox(child: _buildFontSlider(), width: 300),
      ],
    );
  }

  Row _buildContent(BuildContext context, ProverbItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: kPreviewLeftFlex,
          child: _buildImagePanel(context, item),
        ),
        Expanded(
          flex: kPreviewRightFlex,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildTextPanel(context, item),
          ),
        ),
      ],
    );
  }

  RepaintBoundary _buildImagePanel(BuildContext context, ProverbItem item) {
    return RepaintBoundary(
      key: globalKey,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
          color: _kBgColor,
          padding: const EdgeInsets.all(8.0),
          child: EverjapanWatermark(
            child: _buildImageContent(context, item),
          ),
        ),
      ),
    );
  }

  _buildTextPanel(BuildContext context, ProverbItem item) {
    final proverbText = _generateDisplayText(item);
    return SelectableText(proverbText);
  }

  _buildFontSlider() => Row(
        children: [
          const Text('Font:'),
          Expanded(
            child: Slider(
              value: _currentSliderValue,
              min: 48,
              max: 96,
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

  _buildImageContent(BuildContext context, ProverbItem item) {
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
            'Shippori Mincho B1',
            textStyle: const TextStyle(
              fontSize: 40,
              color: _kMainColor,
            ),
          ),
          maxLines: 1,
        ),
        AutoSizeText(
          item.reading,
          textAlign: TextAlign.center,
          style: GoogleFonts.getFont(
            'Shippori Mincho B1',
            textStyle: const TextStyle(fontSize: 28),
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
                  'Ma Shan Zheng',
                  textStyle: const TextStyle(fontSize: 24.0),
                ),
              ),
            )
            .toList(),
        const Gap(32),
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

  _saveProverbAsImage(ProverbItem item) async {
    final bytes = await captureWidget(globalKey);
    await saveImageToFile(bytes!, '${item.name}.png');
  }

  _copyText(ProverbItem item) async {
    final text = _generateDisplayText(item);
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copyied'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
