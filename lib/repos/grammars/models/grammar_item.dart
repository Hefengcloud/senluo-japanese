import 'package:equatable/equatable.dart';

class GrammarItem extends Equatable {
  final String title;

  final List<String> jpMeanings;
  final List<String> cnMeanings;
  final List<String> conjugations;
  final List<String> explanation;
  final List<GrammarExample> examples;

  const GrammarItem.title(String title)
      : this(
          title: title,
          jpMeanings: const [],
          cnMeanings: const [],
          conjugations: const [],
          explanation: const [],
          examples: const [],
        );

  const GrammarItem({
    required this.title,
    required this.jpMeanings,
    required this.cnMeanings,
    required this.conjugations,
    required this.explanation,
    required this.examples,
  });

  static const empty = GrammarItem(
    title: '',
    jpMeanings: [],
    cnMeanings: [],
    conjugations: [],
    explanation: [],
    examples: [],
  );

  @override
  List<Object?> get props => [
        title,
        jpMeanings,
        cnMeanings,
        conjugations,
        explanation,
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
}
