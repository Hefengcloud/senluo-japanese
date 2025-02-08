import 'package:flutter/material.dart';

class TitleView extends StatelessWidget {
  final String title;
  const TitleView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(title, style: textTheme.headlineSmall);
  }
}
