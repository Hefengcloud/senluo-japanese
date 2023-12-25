import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

import 'models/models.dart';

class GojuonRepository {
  static const kYamlFilePath = 'assets/data/gojuon.yaml';

  Future<Gojuon> loadGojuon() async {
    String yamlString = await rootBundle.loadString(kYamlFilePath);
    final yamlMaps = loadYaml(yamlString);
    final seion = yamlMaps['seion'].map<List<Kana>>(lineMapper).toList();
    final dakuon = yamlMaps['dakuon'].map<List<Kana>>(lineMapper).toList();
    final handakuon =
        yamlMaps['handakuon'].map<List<Kana>>(lineMapper).toList();
    final yoon = yamlMaps['yoon'].map<List<Kana>>(lineMapper).toList();

    return Gojuon(
      seion: seion,
      dakuon: dakuon,
      handakuon: handakuon,
      yoon: yoon,
    );
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
