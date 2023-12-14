import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

const _delay = Duration(milliseconds: 800);

class GrammarRepository {
  final _items = <GrammarItem>[
    const GrammarItem.title('〜あっての・・・'),
    const GrammarItem.title('〜いかんでは\n〜いかんによっては'),
    const GrammarItem.title('〜いかんにかかわらず\n〜いかんによらず\n〜いかんをとわず'),
    const GrammarItem.title('〜かたがた'),
    const GrammarItem.title('〜かたわら'),
    const GrammarItem.title('〜がてら'),
  ];

  void addItem(GrammarItem item) => _items.add(item);

  Future<List<GrammarItem>> loadItems() => Future.delayed(_delay, () => _items);
}
