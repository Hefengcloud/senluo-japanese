import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/kana/views/kana_piece_view.dart';

import '../../../repos/gojuon/kana_repository.dart';
import '../../../repos/gojuon/models/models.dart';

const kColumnLabels = ['', '-a', '-i', '-u', '-e', '-o'];

const kCategory2RowLabels = {
  KanaCategory.seion: [
    '-',
    'k-',
    's-',
    't-',
    'n-',
    'h-',
    'm-',
    'y-',
    'r-',
    'w-',
    'N-'
  ],
  KanaCategory.dakuon: [
    'g-',
    'z-',
    'd-',
    'b-',
    'p-',
  ],
};

const kKanaYoonRowLabels = {
  'ky',
  'sh',
  'ch',
  'ny',
  'hy',
  'my',
  'ry',
  'gy',
  'j',
  'by',
  'py'
};

const kKanaLabelStyle = TextStyle(
  fontSize: 10,
  color: Colors.black26,
);

const kTableBottomMargin = 64.0;

class KanaTableView extends StatelessWidget {
  final KanaCategory kanaCategory;
  final List<KanaRow> kanaRows;
  final ValueChanged<Kana> onKanaTap;
  final KanaType kanaType;

  const KanaTableView({
    super.key,
    required this.kanaCategory,
    required this.kanaRows,
    required this.onKanaTap,
    required this.kanaType,
  });

  @override
  Widget build(BuildContext context) {
    final rows = _formateRows();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: kTableBottomMargin),
        child: Table(
          columnWidths: kanaCategory == KanaCategory.yoon
              ? const {}
              : const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
                  4: FlexColumnWidth(2),
                  5: FlexColumnWidth(2),
                },
          children: [
            TableRow(
              children: kColumnLabels
                  .map(
                    (e) => TableCell(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          e,
                          style: kKanaLabelStyle,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            ...rows.mapIndexed((index, kanas) => TableRow(
                  children: _buildTableRow(context, index, kanas),
                )),
          ],
        ),
      ),
    );
  }

  List<TableCell> _buildTableRow(
      BuildContext context, int index, List<Kana> kanas) {
    final cells = kanas
        .map<TableCell>(
          (e) => TableCell(
            child: Card(
              child: InkWell(
                child: KanaPieceView(kana: e, type: kanaType),
                onTap: () => onKanaTap(e),
              ),
            ),
          ),
        )
        .toList();
    cells.insert(
      0,
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            kCategory2RowLabels[kanaCategory]![index],
            style: kKanaLabelStyle,
          ),
        ),
      ),
    );
    return cells;
  }

  List _formateRows() {
    final List<KanaRow> theKanaRows = [];
    for (KanaRow row in kanaRows) {
      final List<Kana> theRow;
      if (row.length == 1) {
        theRow = [Kana.empty, Kana.empty, row[0], Kana.empty, Kana.empty];
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

class KanaTableYoonView extends StatelessWidget {
  final List<KanaRow> kanaRows;
  final KanaType kanaType;
  final ValueChanged<Kana> onKanaTap;

  const KanaTableYoonView({
    super.key,
    required this.kanaRows,
    required this.onKanaTap,
    required this.kanaType,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: kTableBottomMargin),
        child: Column(
          children: kanaRows
              .map(
                (row) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: row
                      .map(
                        (kana) => Expanded(
                          child: Card(
                            child: InkWell(
                              child: KanaPieceView(kana: kana, type: kanaType),
                              onTap: () => onKanaTap(kana),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
