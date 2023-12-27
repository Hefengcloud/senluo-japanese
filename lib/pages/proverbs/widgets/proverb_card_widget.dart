import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';
import 'package:senluo_japanese_cms/repos/proverbs/models/proverb_item.dart';

class ProverbCardWidget extends StatelessWidget {
  final ProverbItem item;
  const ProverbCardWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoSizeText(
              item.name,
              textAlign: TextAlign.center,
              style:
                  theme.textTheme.headlineSmall?.copyWith(color: Colors.purple),
            ),
            AutoSizeText(
              item.reading,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall,
              maxLines: 1,
            ),
            const Spacer(),
            AutoSizeText(
              item.meanings.join('\n'),
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
