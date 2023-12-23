import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/repos/proverbs/models/proverb_item.dart';

class ProverbCardWidget extends StatelessWidget {
  final ProverbItem item;
  const ProverbCardWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.name,
              style: theme.textTheme.headlineSmall,
            ),
            Text(
              item.reading,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
