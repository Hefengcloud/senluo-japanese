import 'package:flutter/material.dart';

class KanaCategoryListView extends StatelessWidget {
  const KanaCategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('清音'),
        ),
        ListTile(
          title: Text('濁音'),
        ),
        ListTile(
          title: Text('拗音'),
        ),
      ],
    );
  }
}
