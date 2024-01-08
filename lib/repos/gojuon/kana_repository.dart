import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

import 'models/models.dart';

typedef KanaRow = List<Kana>;

class KanaRepository {
  static const kYamlFilePath = 'assets/data/kanas.yaml';

  Future<Map<KanaCategory, List<KanaRow>>> loadKanaTable() async {
    String yamlString = await rootBundle.loadString(kYamlFilePath);
    final yaml = loadYaml(yamlString);
    final seion = yaml['seion'].map<List<Kana>>(lineMapper).toList();
    final dakuon = yaml['dakuon'].map<List<Kana>>(lineMapper).toList();
    final handakuon = yaml['handakuon'].map<List<Kana>>(lineMapper).toList();
    final yoon = yaml['yoon'].map<List<Kana>>(lineMapper).toList();

    return {
      KanaCategory.seion: seion,
      KanaCategory.dakuon: dakuon,
      KanaCategory.handakuon: handakuon,
      KanaCategory.yoon: yoon,
    };
  }

  List<Kana> lineMapper(line) {
    return line.map<Kana>(kanaMapper).toList();
  }

  Kana kanaMapper(e) {
    return Kana(
      hiragana: e['h'],
      katakana: e['k'],
      romaji: e['r'],
    );
  }
}
