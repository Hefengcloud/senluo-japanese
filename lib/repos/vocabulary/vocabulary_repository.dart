import 'package:flutter/services.dart';
import 'package:path/path.dart' as Path;
import 'package:senluo_japanese_cms/common/models/meaning.dart';
import 'package:senluo_japanese_cms/helpers/text_helper.dart';
import 'package:senluo_japanese_cms/pages/grammars/helpers/grammar_helper.dart';
import 'package:senluo_japanese_cms/repos/vocabulary/models/vocabulary_menu.dart';
import 'package:yaml/yaml.dart';

import '../../common/models/word.dart';

enum VocabularyType {
  category('カテゴリー別'),
  jlpt('JLPT'),
  textbook('教科書');

  final String text;

  const VocabularyType(this.text);
}

class VocabularyRepository {
  static const _kCategoryIndexFile = 'assets/vocabulary/category/index.yaml';
  static const _kVocabularyDir = 'assets/vocabulary/';

  Future<List<VocabularyMenu>> loadMenus(VocabularyType type) async {
    final yaml = await rootBundle.loadString(_kCategoryIndexFile);
    final dictList = loadYaml(yaml);

    final menus = dictList.map<VocabularyMenu>((e) {
      final name = e['menu'].toString();
      final key = e['key'].toString();
      final subMenus = e['subMenus']
          .map<VocabularyMenu>(
            (entry) => VocabularyMenu(
              name: entry['menu'],
              key: entry['key'],
            ),
          )
          .toList();
      return VocabularyMenu(name: name, key: key, subMenus: subMenus);
    }).toList();

    return menus;
  }

  Future<List<Word>> loadWords(String key) async {
    final filePath = Path.join(_kVocabularyDir, "$key.yaml");
    final yaml = await rootBundle.loadString(filePath);
    final dictList = loadYaml(yaml);
    final words = dictList.map<Word>((e) {
      final parsed = parseMeaning(e['jp']);
      final word = Word(
        text: parsed.text,
        reading: parsed.reading,
        meaning: Meaning(ens: [e['en']], jps: [], zhs: []),
        category: e['group'].toString(),
      );
      return word;
    }).toList();
    return words;
  }
}
