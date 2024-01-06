import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:yaml/yaml.dart';

import '../../../common/models/models.dart';
import '../../../database/grammars/models/grammar_item_model.dart';

class GrammarItem extends Equatable {
  final String name;
  final String level;
  final Meaning meaning;
  final List<String> conjugations;
  final List<String> explanations;
  final List<Example> examples;

  const GrammarItem({
    required this.name,
    required this.level,
    required this.meaning,
    required this.conjugations,
    required this.explanations,
    required this.examples,
  });

  @override
  List<Object?> get props => [
        name,
        level,
        meaning,
        conjugations,
        explanations,
        examples,
      ];

  GrammarItem copyWith({
    String? name,
    String? level,
    Meaning? meaning,
    List<String>? conjugations,
    List<String>? explanations,
    List<Example>? examples,
  }) {
    return GrammarItem(
      name: name ?? this.name,
      level: level ?? this.level,
      meaning: meaning ?? this.meaning,
      conjugations: conjugations ?? this.conjugations,
      explanations: explanations ?? this.explanations,
      examples: examples ?? this.examples,
    );
  }

  const GrammarItem.simple(int id, String name, String level)
      : this(
          name: name,
          level: level,
          meaning: const Meaning(jps: [], zhs: [], ens: []),
          conjugations: const [],
          explanations: const [],
          examples: const [],
        );

  factory GrammarItem.fromYaml(YamlMap yaml) {
    final meaning = yaml['meanings'];

    return GrammarItem(
      name: yaml['pattern'],
      level: yaml['level'],
      meaning: Meaning(
        jps: meaning['jp']?.map<String>((e) => e.toString()).toList() ?? [],
        zhs: meaning['cn']?.map<String>((e) => e.toString()).toList() ?? [],
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
                zh: e['cn'] ?? '',
              ))
          .toList(),
    );
  }

  factory GrammarItem.from(GrammarItemModel model) {
    // Meanings
    final Map<String, dynamic> meaning = jsonDecode(model.meaning);
    final jpMeanings = meaning['jp'].map<String>((e) => e.toString()).toList();
    final cnMeanings = meaning['cn'].map<String>((e) => e.toString()).toList();

    // Examples
    final examples = jsonDecode(model.example)
        .map<Example>((e) => Example(jp: e['jp'], zh: e['cn'], en: e['en']))
        .toList();
    return GrammarItem(
      name: model.name,
      level: model.level,
      meaning: Meaning(jps: jpMeanings, zhs: cnMeanings, ens: []),
      conjugations: model.conjugation.split('#'),
      explanations:
          model.explanation.isNotEmpty ? model.explanation.split('#') : [],
      examples: examples,
    );
  }

  static const empty = GrammarItem(
    name: '',
    level: '',
    meaning: Meaning.empty,
    conjugations: [],
    explanations: [],
    examples: [],
  );
}
