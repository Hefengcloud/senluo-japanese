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
          bottom: 100,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: 0.05,
              child: Transform.rotate(
                angle: -math.pi / 18,
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
