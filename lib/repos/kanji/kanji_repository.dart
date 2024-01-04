import 'package:flutter/services.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';
import 'package:yaml/yaml.dart';

import 'models/kanji_model.dart';

class KanjiRepository {
  static const _kJLPTFile = 'assets/kanji/index.yaml';
  final Map<JLPTLevel, List<Kanji>> _jlptKanjiMap = {};

  Future<List<Kanji>> loadJlptKanjis(JLPTLevel level) async {
    if (_jlptKanjiMap.isEmpty) {
      await _loadAllJlptKanjis();
    }

    if (_jlptKanjiMap.containsKey(level)) {
      return _jlptKanjiMap[level]!;
    }

    return [];
  }

  _loadAllJlptKanjis() async {
    final yamlStr = await rootBundle.loadString(_kJLPTFile);
    final yamlMaps = loadYaml(yamlStr);
    for (final map in yamlMaps) {
      final level = JLPTLevel.fromString(map['level']);
      final kanjis = map['kanjis']
          .map<Kanji>((kanji) => Kanji(
                char: kanji['char'],
                key: kanji['key'],
                level: level,
              ))
          .toList();
      _jlptKanjiMap[level] = kanjis;
    }
  }

  Future<KanjiDetail> loadKanjiDetail(Kanji kanji) async {
    final yamlFilePath = 'assets/kanji/${kanji.level.name}/${kanji.key}.yaml';
    try {
      final yamlStr = await rootBundle.loadString(yamlFilePath);
      final dict = loadYaml(yamlStr);
      return KanjiDetail(
        char: kanji.char,
        key: kanji.key,
        level: kanji.level,
        kunyomis: dict['kun_yomis'].map<String>((e) => e.toString()).toList(),
        onyomis: dict['on_yomis'].map<String>((e) => e.toString()).toList(),
        meaning: dict['meaning'].toString(),
        radical: dict['radical'],
        strokeCount: dict['stroke_count'],
        idioms: dict['idioms'].map<String>((e) => e.toString()).toList(),
        proverbs: dict['proverbs'].map<String>((e) => e.toString()).toList(),
        words: dict['words'].map<String>((e) => e.toString()).toList(),
      );
    } catch (e) {
      return KanjiDetail.empty;
    }
  }
}
