import 'package:flutter/services.dart';
import 'package:senluo_japanese_cms/common/constants/kanas.dart';
import 'package:senluo_japanese_cms/repos/proverbs/models/proverb_item.dart';
import 'package:yaml/yaml.dart';

class ProverbRepository {
  static const kYamlFilePath = 'assets/data/proverbs.yaml';

  List<ProverbItem> _items = [];

  Future<List<ProverbItem>> loadProverbs() async {
    if (_items.isNotEmpty) return _items;

    String yamlString = await rootBundle.loadString(kYamlFilePath);
    final yamlMaps = loadYaml(yamlString);
    _items = yamlMaps
        .map<ProverbItem>(
          (map) => ProverbItem(
            name: map['item'],
            reading: map['yomi'],
            meanings: map['zh'].map<String>((e) => e.toString()).toList(),
            examples: map['examples']
                    ?.map<ProverbExample>((e) => ProverbExample(
                          jp: e['jp'],
                          zh: e['zh'],
                        ))
                    .toList() ??
                [],
          ),
        )
        .toList();
    return _items;
  }

  Future<int> countProverbs() async {
    return _items.length;
  }

  Future<List<ProverbItem>> searchProverbs(String keyword) async {
    return _items
        .where((e) => e.name.contains(keyword) || e.reading.contains(keyword))
        .toList();
  }

  Future<List<ProverbItem>> loadProverbsByKanaLine(KanaLine kanaLine) async {
    if (kanaLine == KanaLine.none) {
      return _items;
    }
    return _items.where((e) {
      final firstLetter = e.reading[0];
      return kanaLine.kanas.contains(firstLetter);
    }).toList();
  }
}
