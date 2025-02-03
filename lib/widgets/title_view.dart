import 'package:flutter/material.dart';

class TitleView extends StatelessWidget {
  final String title;
  const TitleView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }
}
