import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/gojuon/widgets/kana_card_view.dart';

import '../../../repos/gojuon/models/models.dart';

typedef KanaTapCallback = void Function(Kana kana);

class KanaTableView extends StatelessWidget {
  final Gojuon gojuon;
  final KanaTapCallback onKanaTap;

  const KanaTableView({
    super.key,
    required this.gojuon,
    required this.onKanaTap,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const TabBar(
            tabs: [
              Tab(text: '清音'),
              Tab(text: '濁音・半濁音'),
              Tab(text: '拗音'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildTable(gojuon.seion),
                _buildTable([
                  ...gojuon.dakuon,
                  ...gojuon.handakuon,
                ]),
                _buildTable(gojuon.yoon),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildTable(List<List<Kana>> kanas) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: kanas.map((line) {
            if (line.length == 3) {
              line
                ..insert(1, Kana.empty)
                ..insert(3, Kana.empty);
            } else if (line.length < 3) {
              line.insertAll(1, List.filled(5 - line.length, Kana.empty));
            }
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: line
                  .map(
                    (kana) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: kana != Kana.empty
                            ? InkWell(
                                child: KanaCardView(kana: kana),
                                onTap: () => onKanaTap(kana),
                              )
                            : const Spacer(),
                      ),
                    ),
                  )
                  .toList(),
            );
          }).toList(),
        ),
      ),
    );
  }
}
