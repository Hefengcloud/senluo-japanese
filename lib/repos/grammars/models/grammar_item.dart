import 'package:equatable/equatable.dart';

class GrammarItem extends Equatable {
  final String title;

  final List<String> jpMeanings;
  final List<String> cnMeanings;

  final List<String> conjugations;

  final List<String> explanation;

  const GrammarItem.title(String title)
      : this(
          title: title,
          jpMeanings: const [],
          cnMeanings: const [],
          conjugations: const [],
          explanation: const [],
        );

  const GrammarItem({
    required this.title,
    required this.jpMeanings,
    required this.cnMeanings,
    required this.conjugations,
    required this.explanation,
  });

  static const empty = GrammarItem(
    title: '',
    jpMeanings: [],
    cnMeanings: [],
    conjugations: [],
    explanation: [],
  );

  @override
  List<Object?> get props => [
        title,
        jpMeanings,
        cnMeanings,
        conjugations,
        explanation,
      ];
}

class GrammarExampleSentence {
  final String jp;
  final String cn;

  GrammarExampleSentence({
    required this.jp,
    required this.cn,
  });
}
