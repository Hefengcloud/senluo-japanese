import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/kana/views/kana_piece_view.dart';

import '../../../repos/gojuon/kana_repository.dart';
import '../../../repos/gojuon/models/models.dart';

typedef KanaTapCallback = void Function(Kana kana);

class KanaTableView extends StatelessWidget {
  static const kRowLabels = [
    '',
    'k~',
    's~',
    't~',
    'n~',
    'h~',
    'm~',
    'y~',
    'r~',
    'r~',
    'w~'
  ];
  static const kColumnLabels = ['', '~a', '~i', '~u', '~e', '~o'];

  static const _labelStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.green,
  );

  final KanaCategory kanaType;
  final List<KanaRow> kanaRows;
  final KanaTapCallback onKanaTap;

  const KanaTableView({
    super.key,
    required this.kanaType,
    required this.kanaRows,
    required this.onKanaTap,
  });

  @override
  Widget build(BuildContext context) {
    final rows = kanaType == KanaCategory.seion ? _formateRows() : kanaRows;
    return SingleChildScrollView(
      child: Table(
        columnWidths: kanaType == KanaCategory.seion
            ? {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(2),
                5: FlexColumnWidth(2),
              }
            : null,
        children: [
          if (kanaType == KanaCategory.seion)
            TableRow(
              children: kColumnLabels
                  .map((e) => TableCell(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(e, style: _labelStyle),
                        ),
                      ))
                  .toList(),
            ),
          ...rows
              .mapIndexed((index, kanas) => TableRow(
                    children: _buildTableRow(index, kanas),
                  ))
              .toList()
        ],
      ),
    );
  }

  List<TableCell> _buildTableRow(int index, List<Kana> kanas) {
    final cells = kanas
        .map<TableCell>((e) => TableCell(child: KanaPieceView(kana: e)))
        .toList();
    if (kanaType == KanaCategory.seion) {
      cells.insert(
        0,
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              kRowLabels[index],
              style: _labelStyle,
            ),
          ),
        ),
      );
    }
    return cells;
  }

  List _formateRows() {
    final List<KanaRow> theKanaRows = [];
    for (KanaRow row in kanaRows) {
      final List<Kana> theRow;
      if (row.length == 1) {
        theRow = List.from(row)
          ..addAll([Kana.empty, Kana.empty, Kana.empty, Kana.empty]);
      } else if (row.length == 2) {
        theRow = List.from(row)
          ..insertAll(1, [Kana.empty, Kana.empty, Kana.empty]);
      } else if (row.length == 3) {
        theRow = List.from(row)
          ..insert(1, Kana.empty)
          ..insert(3, Kana.empty);
      } else {
        theRow = List.from(row);
      }

      theKanaRows.add(theRow);
    }
    return theKanaRows;
  }
}
