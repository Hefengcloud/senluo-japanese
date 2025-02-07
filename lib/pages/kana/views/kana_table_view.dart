import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/kana/kana_preview_page.dart';
import 'package:senluo_japanese_cms/pages/kana/views/kana_piece_view.dart';

import '../../../repos/gojuon/kana_repository.dart';
import '../../../repos/gojuon/models/models.dart';

typedef KanaTapCallback = void Function(Kana kana);

const kColumnLabels = ['', 'a', 'i', 'u', 'e', 'o'];
const kKanaYoonColumnLabels = ['', 'a', 'u', 'o'];

const kCategory2RowLabels = {
  KanaCategory.seion: ['-', 'k', 's', 't', 'n', 'h', 'm', 'y', 'r', 'w', 'N'],
  KanaCategory.dakuon: [
    'g',
    'z',
    'd',
    'b',
    'p',
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
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.black26,
);

class KanaTableView extends StatelessWidget {
  final KanaCategory kanaCategory;
  final List<KanaRow> kanaRows;
  final KanaTapCallback onKanaTap;

  const KanaTableView({
    super.key,
    required this.kanaCategory,
    required this.kanaRows,
    required this.onKanaTap,
  });

  @override
  Widget build(BuildContext context) {
    final rows = _formateRows();
    return SingleChildScrollView(
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
    );
  }

  List<TableCell> _buildTableRow(
    BuildContext context,
    int index,
    List<Kana> kanas,
  ) {
    final cells = kanas
        .map<TableCell>(
          (e) => TableCell(
            child: Card(
              child: InkWell(
                child: KanaPieceView(kana: e),
                onTap: () => _showKanaPreviewDialog(context, e),
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

  _showKanaPreviewDialog(BuildContext context, Kana kana) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SizedBox(
            width: 600,
            height: 800,
            child: KanaPreviewPage(kana: kana),
          ),
        ),
      );
}
