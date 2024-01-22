import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';
import 'package:yaml/yaml.dart';

import '../../../common/models/models.dart';
import '../../../database/grammars/models/grammar_item_model.dart';

class GrammarItem extends Equatable {
  final String key;
  final String name;
  final JLPTLevel level;
  final Meaning meaning;
  final List<String> conjugations;
  final List<String> explanations;
  final List<Example> examples;

  const GrammarItem({
    required this.key,
    required this.name,
    required this.level,
    required this.meaning,
    required this.conjugations,
    required this.explanations,
    required this.examples,
  });

  @override
  List<Object?> get props => [
        key,
        name,
        level,
        meaning,
        conjugations,
        explanations,
        examples,
      ];

  GrammarItem copyWith({
    String? key,
    String? name,
    JLPTLevel? level,
    Meaning? meaning,
    List<String>? conjugations,
    List<String>? explanations,
    List<Example>? examples,
  }) {
    return GrammarItem(
      key: key ?? this.key,
      name: name ?? this.name,
      level: level ?? this.level,
      meaning: meaning ?? this.meaning,
      conjugations: conjugations ?? this.conjugations,
      explanations: explanations ?? this.explanations,
      examples: examples ?? this.examples,
    );
  }

  GrammarItem.simple(int id, String name, String level)
      : this(
          key: '',
          name: name,
          level: JLPTLevel.fromString(level),
          meaning: const Meaning(jps: [], zhs: [], ens: []),
          conjugations: const [],
          explanations: const [],
          examples: const [],
        );

  factory GrammarItem.fromYaml(String key, YamlMap yaml) {
    final meaning = yaml['meanings'];

    return GrammarItem(
      key: key,
      name: yaml['name'],
      level: JLPTLevel.fromString(yaml['level']),
      meaning: Meaning(
        jps: meaning['jp']?.map<String>((e) => e.toString()).toList() ?? [],
        zhs: meaning['zh']?.map<String>((e) => e.toString()).toList() ?? [],
        ens: meaning['en']?.map<String>((e) => e.toString()).toList() ?? [],
      ),
      conjugations:
          yaml['conjugations']?.map<String>((e) => e.toString()).toList() ?? [],
      explanations:
          yaml['explanations']?.map<String>((e) => e.toString()).toList() ?? [],
      examples: yaml['examples']
          .map<Example>((e) => Example(
                en: e['en'] ?? '',
                jp: e['jp'] ?? '',
                zh: e['zh'] ?? '',
              ))
          .toList(),
    );
  }

  factory GrammarItem.from(GrammarItemModel model) {
    // Meanings
    final Map<String, dynamic> meaning = jsonDecode(model.meaning);
    final jpMeanings = meaning['jp'].map<String>((e) => e.toString()).toList();
    final cnMeanings = meaning['zh'].map<String>((e) => e.toString()).toList();

    // Examples
    final examples = jsonDecode(model.example)
        .map<Example>((e) => Example(jp: e['jp'], zh: e['zh'], en: e['en']))
        .toList();
    return GrammarItem(
      key: '',
      name: model.name,
      level: JLPTLevel.fromString(model.level),
      meaning: Meaning(jps: jpMeanings, zhs: cnMeanings, ens: []),
      conjugations: model.conjugation.split('#'),
      explanations:
          model.explanation.isNotEmpty ? model.explanation.split('#') : [],
      examples: examples,
    );
  }

  static const empty = GrammarItem(
    key: '',
    name: '',
    level: JLPTLevel.none,
    meaning: Meaning.empty,
    conjugations: [],
    explanations: [],
    examples: [],
  );
}
