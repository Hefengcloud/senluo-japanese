import 'package:flutter/services.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/category_model.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';
import 'package:yaml/yaml.dart';

class OnomatopoeiaRepository {
  final _itemsFile = 'assets/onomatopoeia/items.yaml';
  final _collectionsFile = 'assets/onomatopoeia/collections.yaml';

  List<OnomatopoeiaCategory> _categories = [];
  List<Onomatopoeia> _items = [];

  OnomatopoeiaRepository();

  Future<List<OnomatopoeiaCategory>> loadCategories() async {
    if (_categories.isNotEmpty) return _categories;

    final yamlStr = await rootBundle.loadString(_collectionsFile);
    final yamlMaps = loadYaml(yamlStr);
    _categories = yamlMaps.map<OnomatopoeiaCategory>((e) {
      final items = e['items'].map<String>((e) => e.toString()).toList();
      return OnomatopoeiaCategory(
        key: e['category'],
        name: e['name'],
        items: items,
      );
    }).toList();
    return _categories;
  }

  Future<List<Onomatopoeia>> loadItems() async {
    if (_items.isNotEmpty) return _items;

    final yamlStr = await rootBundle.loadString(_itemsFile);
    final yamlMap = loadYaml(yamlStr);
    _items =
        yamlMap.map<Onomatopoeia>((e) => Onomatopoeia.fromYamlMap(e)).toList();
    return _items;
  }

  Future<List<Onomatopoeia>> loadCategoryItems(
      OnomatopoeiaCategory category) async {
    if (_items.isEmpty) _items = await loadItems();
    return _items.where((e) => category.items.contains(e.key)).toList();
  }
}
