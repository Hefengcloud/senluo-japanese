import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/colors.dart';

enum LogoLang {
  zh,
  en,
}

class EverJapanLogo extends StatelessWidget {
  final double logoSize;
  final double fontSize;
  final LogoLang lang;

  const EverJapanLogo({
    super.key,
    this.logoSize = 32,
    this.fontSize = 16,
    this.lang = LogoLang.zh,
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
          lang == LogoLang.zh ? '日系生活家' : 'everjapan',
          style: TextStyle(
            color: kBrandColor,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
