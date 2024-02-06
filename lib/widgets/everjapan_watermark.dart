import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'everjapan_logo.dart';

class EverjapanWatermark extends StatelessWidget {
  const EverjapanWatermark({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: child,
        ),
        Positioned.fill(
          right: 16,
          child: Align(
            alignment: Alignment.center,
            child: Opacity(
              opacity: 0.05,
              child: Transform.rotate(
                angle: -math.pi / 9,
                child: const EverJapanLogo(
                  lang: LogoLang.zh,
                  logoSize: 48,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
