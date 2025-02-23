import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

import 'models/models.dart';

typedef KanaRow = List<Kana>;

class KanaRepository {
  static const kYamlFilePath = 'assets/data/kanas.yaml';
  static const kRelatedWordsPath = 'assets/kana/words/kana_words.yaml';

  Map<KanaCategory, List<KanaRow>> kanaTable = {};

  Map<String, List<String>> kanaWords = {};

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

  Future<List<String>> loadKanaWords(String kana) async {
    if (kanaWords.isEmpty) {
      String yamlString = await rootBundle.loadString(kRelatedWordsPath);
      final yaml = loadYaml(yamlString);

      // Convert YamlMap to a regular Dart Map<String, List<String>>
      kanaWords = (yaml as Map).map<String, List<String>>(
        (key, value) => MapEntry(key.toString(), List<String>.from(value)),
      );
    }

    return kanaWords[kana]!;
  }

  Future<KanaRow> loadKanaRow(Kana kana, KanaCategory category) async {
    if (kanaTable.isEmpty) {
      kanaTable = await loadKanaTable();
    }
    final kanaRows = kanaTable[category]!;
    final kanaIndex = kanaRows.indexWhere((row) => row.contains(kana));
    return kanaRows[kanaIndex];
  }

  Future<KanaRow> loadNextKanaRow(Kana kana, KanaCategory category) async {
    if (kanaTable.isEmpty) {
      kanaTable = await loadKanaTable();
    }
    final kanaRows = kanaTable[category]!;
    final kanaIndex = kanaRows.indexWhere((row) => row.contains(kana));
    if (kanaIndex == kanaRows.length - 1) {
      return kanaRows[0];
    }
    return kanaRows[kanaIndex + 1];
  }

  Future<KanaRow> loadPreviousKanaRow(Kana kana, KanaCategory category) async {
    if (kanaTable.isEmpty) {
      kanaTable = await loadKanaTable();
    }
    final kanaRows = kanaTable[category]!;
    final kanaIndex = kanaRows.indexWhere((row) => row.contains(kana));
    if (kanaIndex == 0) {
      return kanaRows[kanaRows.length - 1];
    }
    return kanaRows[kanaIndex - 1];
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
