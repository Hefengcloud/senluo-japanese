import 'package:flutter/material.dart';

class ExpressionCategoryListView extends StatelessWidget {
  const ExpressionCategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('Greetings'),
          onTap: () {},
        ),
        ListTile(
          title: const Text('Hotel'),
          onTap: () {},
        ),
      ],
    );
  }
}
