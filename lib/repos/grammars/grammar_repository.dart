import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

const _delay = Duration(milliseconds: 800);

class GrammarRepository {
  final _items = <GrammarItem>[
    const GrammarItem(
      title: '〜あっての・・・',
      jpMeanings: [
        '〜があるから・・・が成り立つ',
        '〜がなかったら、・・・が成り立たない',
      ],
      cnMeanings: [
        '有〜才〜',
        '没有〜就不能（没有）〜',
      ],
      conjugations: ['N1 + あってのN2'],
      explanation: [],
    ),
    const GrammarItem.title('〜いかんでは\n〜いかんによっては'),
    const GrammarItem.title('〜いかんにかかわらず\n〜いかんによらず\n〜いかんをとわず'),
    const GrammarItem.title('〜かたがた'),
    const GrammarItem.title('〜かたわら'),
    const GrammarItem.title('〜がてら'),
  ];

  void addItem(GrammarItem item) => _items.add(item);

  Future<List<GrammarItem>> loadItems() => Future.delayed(_delay, () => _items);
}
