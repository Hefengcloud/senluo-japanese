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
      examples: [
        GrammarExample(
          jp: 'お客様 **あっての** 仕事ですから、いつもご来店いただくお客様には感謝しております。',
          cn: '正因为有了顾客，工作才得以存在，所以我们对经常光临的顾客深表感谢。',
        ),
        GrammarExample(
          jp: '学生 **あっての** 学校ですから、いくら設備が良くても、素晴らしい先生がいても、学生が来なければ意味がない。',
          cn: '因为有了学生，学校才存在。再好的设施，再优秀的老师，如果没有学生前来，都是没有意义的。',
        ),
      ],
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
