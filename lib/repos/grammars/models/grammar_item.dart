import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../database/grammars/models/grammar_item_model.dart';

class GrammarItem extends Equatable {
  final int id;
  final String name;
  final String level;
  final GrammarMeaning meaning;
  final List<String> conjugations;
  final List<String> explanations;
  final List<GrammarExample> examples;

  const GrammarItem({
    this.id = 0,
    required this.name,
    required this.level,
    required this.meaning,
    required this.conjugations,
    required this.explanations,
    required this.examples,
  });

  const GrammarItem.simple(int id, String name)
      : this(
          id: id,
          name: name,
          level: '',
          meaning: const GrammarMeaning(jp: [], cn: []),
          conjugations: const [],
          explanations: const [],
          examples: const [],
        );

  factory GrammarItem.from(GrammarItemModel model) {
    // Meanings
    final Map<String, dynamic> meaning = jsonDecode(model.meaning);
    final jpMeanings = meaning['jp'].map<String>((e) => e.toString()).toList();
    final cnMeanings = meaning['cn'].map<String>((e) => e.toString()).toList();

    // Examples
    final examples = jsonDecode(model.example)
        .map<GrammarExample>((e) => GrammarExample(jp: e['jp'], cn: e['cn']))
        .toList();
    return GrammarItem(
      id: model.id,
      name: model.name,
      level: model.level,
      meaning: GrammarMeaning(jp: jpMeanings, cn: cnMeanings),
      conjugations: model.conjugation.split('#'),
      explanations: model.explanation.split('#'),
      examples: examples,
    );
  }

  static const empty = GrammarItem(
    name: '',
    level: '',
    meaning: GrammarMeaning(jp: [], cn: []),
    conjugations: [],
    explanations: [],
    examples: [],
  );

  @override
  List<Object?> get props => [
        name,
        meaning,
        conjugations,
        explanations,
        examples,
      ];
}

class GrammarExample {
  final String jp;
  final String cn;

  const GrammarExample({
    required this.jp,
    required this.cn,
  });

  Map<String, dynamic> toJson() {
    return {
      'jp': jp,
      'cn': cn,
    };
  }
}

class GrammarMeaning {
  final List<String> jp;
  final List<String> cn;

  const GrammarMeaning({
    required this.jp,
    required this.cn,
  });

  Map<String, dynamic> toJson() {
    return {
      'jp': jp,
      'cn': cn,
    };
  }
}
