import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class TitleView extends StatelessWidget {
  final String title;
  const TitleView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      title,
      style: Device.get().isPhone
          ? textTheme.headlineSmall
          : textTheme.headlineLarge,
    );
  }
}
