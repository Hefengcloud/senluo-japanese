import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/colors.dart';

class EverJapanLogo extends StatelessWidget {
  final double logoSize;
  final double fontSize;
  const EverJapanLogo({
    super.key,
    this.logoSize = 32,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/images/sushi.svg',
          height: logoSize,
          width: logoSize,
        ),
        Text(
          '日系生活家',
          style: TextStyle(
            color: kBrandColor,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
