import 'dart:convert';

import 'package:senluo_japanese_cms/database/database_helper.dart';
import 'package:senluo_japanese_cms/database/grammars/models/grammar_item_model.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

class GrammarRepository {
  Future<void> addItem(GrammarItem item) async {
    await DatabaseHelper().insertGrammarItem(
      GrammarItemModel(
        id: 0,
        name: item.name,
        level: item.level,
        meaning: jsonEncode(item.meaning.toJson()),
        conjugation: item.conjugations.join('#'),
        explanation: item.explanations.join('#'),
        example: jsonEncode(item.examples.map((e) => e.toJson()).toList()),
      ),
    );
  }

  Future<List<GrammarItem>> loadItems() async {
    final models = await DatabaseHelper().loadGrammarItems();
    return models.map((e) => GrammarItem.simple(e.id, e.name)).toList();
  }

  Future<GrammarItem> loadItem(int id) async {
    final model = await DatabaseHelper().loadGrammarItem(id);
    return GrammarItem.from(model);
  }

  Future<bool> delItem(int id) async {
    final count = await DatabaseHelper().delGrammarItem(id);
    return count > 0;
  }
}
