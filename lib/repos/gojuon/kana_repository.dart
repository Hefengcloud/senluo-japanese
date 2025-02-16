import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

import 'models/models.dart';

typedef KanaRow = List<Kana>;

class KanaRepository {
  static const kYamlFilePath = 'assets/data/kanas.yaml';

  Map<KanaCategory, List<KanaRow>> kanaTable = {};

  Future<Map<KanaCategory, List<KanaRow>>> loadKanaTable() async {
    if (kanaTable.isNotEmpty) {
      return kanaTable;
    }
    String yamlString = await rootBundle.loadString(kYamlFilePath);
    final yaml = loadYaml(yamlString);
    final seion = yaml['seion'].map<List<Kana>>(lineMapper).toList();
    final dakuon = yaml['dakuon'].map<List<Kana>>(lineMapper).toList();
    final yoon = yaml['yoon'].map<List<Kana>>(lineMapper).toList();

    kanaTable = {
      KanaCategory.seion: seion,
      KanaCategory.dakuon: dakuon,
      KanaCategory.yoon: yoon,
    };

    return kanaTable;
  }

  Future<KanaRow> loadKanaRow(Kana kana, KanaCategory category) async {
    if (kanaTable.isEmpty) {
      kanaTable = await loadKanaTable();
    }
    final kanaRows = kanaTable[category]!;
    final kanaIndex = kanaRows.indexWhere((row) => row.contains(kana));
    return kanaRows[kanaIndex];
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
