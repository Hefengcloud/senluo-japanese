import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/kana/views/kana_piece_view.dart';

import '../../../repos/gojuon/kana_repository.dart';
import 'kana_table_view.dart';

class KanaTableYoonView extends StatelessWidget {
  final List<KanaRow> kanaRows;
  final KanaTapCallback onKanaTap;

  const KanaTableYoonView({
    super.key,
    required this.kanaRows,
    required this.onKanaTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: kanaRows
            .map<Row>(
              (row) => Row(
                mainAxisSize: MainAxisSize.max,
                children: row
                    .map(
                      (kana) => Card(
                        child: InkWell(
                          child: KanaPieceView(kana: kana),
                          onTap: () => onKanaTap(kana),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}
