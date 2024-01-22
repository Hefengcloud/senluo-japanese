import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/helpers/image_helper.dart';

class CraftifyImageDialog extends StatefulWidget {
  const CraftifyImageDialog({super.key});

  @override
  State<CraftifyImageDialog> createState() => _CraftifyImageDialogState();
}

class _CraftifyImageDialogState extends State<CraftifyImageDialog> {
  static const kLeftColor = Color(0xFFBD272D);
  static const kRightColor = Color(0xFF5995F0);
  static const _kSquareTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 32,
  );

  bool _rectangle = false;
  String _leftText = '日本語文法';
  String _rightText = '国語文法';

  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RepaintBoundary(
          key: _globalKey,
          child: _buildCover(context, _rectangle),
        ),
        const Gap(16),
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() {
                _rectangle = !_rectangle;
              }),
              icon: Icon(_rectangle
                  ? Icons.rectangle_outlined
                  : Icons.square_outlined),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.abc),
            ),
            IconButton(
              onPressed: () => _saveImage(context),
              icon: Icon(Icons.save),
            ),
          ],
        ),
      ],
    );
  }

  _saveImage(BuildContext context) async {
    final bytes = await captureWidget(_globalKey);
    if (bytes != null) {
      await saveImageToFile(
        bytes,
        "cover-${_rectangle ? 'rect' : 'square'}.png",
      );
    }
  }

  Widget _buildCover(BuildContext context, bool rectangle) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _rectangle
          ? _buildRectangleCover(context)
          : _buildSquareCover(context),
    );
  }

  Widget _buildRectangleCover(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.35,
      child: Stack(
        children: [
          ClipPath(
            child: Container(
              decoration: const BoxDecoration(color: kLeftColor),
            ),
          ),
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              decoration: const BoxDecoration(color: kRightColor),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: _buildText(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSquareCover(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  width: 340,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: kLeftColor),
                  child: Text(
                    _leftText,
                    style: _kSquareTextStyle,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: 340,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: kRightColor),
                  child: Text(
                    _rightText,
                    style: _kSquareTextStyle,
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: _buildVersus(false),
            ),
          ),
        ],
      ),
    );
  }

  Row _buildText() {
    return Row(
      children: [
        _buildSideText('日本語文法', Color(0xFF6CAFFF), true),
        _buildVersus(true),
        _buildSideText('国語文法', Color(0xFFDB313E), false),
      ],
    );
  }

  Container _buildVersus(bool large) {
    return Container(
      width: large ? 64 : 48,
      height: large ? 64 : 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(large ? 32 : 24),
      ),
      child: Text(
        'と',
        style: TextStyle(
          fontSize: large ? 24 : 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Expanded _buildSideText(String text, Color color, bool left) {
    return Expanded(
      flex: 1,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: left
              ? const EdgeInsets.only(left: 64)
              : const EdgeInsets.only(right: 64),
          child: Container(
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(80),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showTextInput(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Input text'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'left text'),
              ),
              TextField(
                decoration: InputDecoration(hintText: 'right text'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(onPressed: () {}, child: Text('Cancel')),
            ElevatedButton(onPressed: () {}, child: Text('OK')),
          ],
        ),
      );
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width * 0.618, 0);
    path.lineTo(size.width * (1 - 0.618), size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
