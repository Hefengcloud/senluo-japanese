import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/repos/gojuon/models/models.dart';
import 'package:tuple/tuple.dart';

class KanaCategoryListView extends StatelessWidget {
  final Function(KanaCategory type) onKanaTypeSelected;
  final KanaCategory selectedType;

  const KanaCategoryListView({
    super.key,
    required this.onKanaTypeSelected,
    required this.selectedType,
  });

  static const _kKanaEntries = [
    Tuple2(KanaCategory.seion, '清音（五十音）'),
    Tuple2(KanaCategory.dakuon, '濁音・半濁音'),
    Tuple2(KanaCategory.yoon, '拗音'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: const Text('仮名'),
          initiallyExpanded: true,
          children: _kKanaEntries
              .map((e) => ListTile(
                    leading: const Icon(Icons.arrow_right),
                    trailing: selectedType == e.item1
                        ? const Icon(Icons.check)
                        : null,
                    title: Text(e.item2),
                    onTap: () => onKanaTypeSelected(e.item1),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
