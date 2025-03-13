import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';
import 'package:senluo_japanese_cms/database/database_helper.dart';
import 'package:senluo_japanese_cms/database/grammars/models/grammar_item_model.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_entry.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';
import 'package:yaml/yaml.dart';
// ignore: library_prefixes
import 'package:path/path.dart' as Path;

class GrammarRepository {
  static const _kIndexFile = 'assets/grammar/index.yaml';
  static const _kGrammarDir = 'assets/grammar';

  Future<Map<JLPTLevel, List<GrammarEntry>>> loadEntries() async {
    final yamlString = await rootBundle.loadString(_kIndexFile);
    final yamlList = loadYaml(yamlString);
    Map<JLPTLevel, List<GrammarEntry>> dict = {};
    for (var yaml in yamlList) {
      final level = JLPTLevel.fromString(yaml['level']);
      final entries = yaml['items']
          .map<GrammarEntry>((e) => GrammarEntry(
                name: e['name'],
                key: e['key'],
                level: level,
              ))
          .toList();
      dict.putIfAbsent(level, () => entries);
    }
    return dict;
  }

  Future<GrammarItem> loadItem(GrammarEntry entry) async {
    final filePath = Path.join(
        _kGrammarDir, entry.level.name.toLowerCase(), "${entry.key}.yaml");
    final yamlString = await rootBundle.loadString(filePath);
    final yaml = loadYaml(yamlString);
    return GrammarItem.fromYaml(entry.key, yaml);
  }
}
