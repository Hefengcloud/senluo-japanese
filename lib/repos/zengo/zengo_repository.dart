import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

import 'models/zengo_item.dart';

class ZengoRepository {
  static const kYamlFilePath = 'assets/data/zengo.yaml';

  final List<ZengoCategory> _items = [];

  Future<List<ZengoCategory>> loadZengos() async {
    if (_items.isNotEmpty) return _items;

    String yamlString = await rootBundle.loadString(kYamlFilePath);
    final categories = loadYaml(yamlString);
    final items = categories.map<ZengoCategory>((category) {
      final name = category["category"];
      final words = category["list"]
          .map<Zengo>(
            (e) => Zengo(
              lines: e["zen"].map<String>((e) => e.toString()).toList(),
              readings: e["yomi"].map<String>((e) => e.toString()).toList(),
              meaning: e["imi"].toString(),
            ),
          )
          .toList();

      return ZengoCategory(name: name, items: words);
    }).toList();

    _items.addAll(items);

    return _items;
  }
}
