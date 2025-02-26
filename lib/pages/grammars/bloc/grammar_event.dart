part of 'grammar_bloc.dart';

sealed class GrammarEvent extends Equatable {
  const GrammarEvent();
}

class GrammarStarted extends GrammarEvent {
  @override
  List<Object?> get props => [];
}

class GrammarLevelChanged extends GrammarEvent {
  final JLPTLevel level;

  const GrammarLevelChanged({required this.level});

  @override
  List<Object?> get props => [level];
}

class GrammarEntryChanged extends GrammarEvent {
  final GrammarEntry entry;

  const GrammarEntryChanged({
    required this.entry,
  });

  @override
  List<Object> get props => [entry];
}

class GrammarItemChanged extends GrammarEvent {
  final bool previous;

  const GrammarItemChanged({required this.previous});

  @override
  List<Object?> get props => [previous];
}

class GrammarKeywordChanged extends GrammarEvent {
  final String? keyword;

  const GrammarKeywordChanged({
    required this.keyword,
  });

  @override
  List<Object?> get props => [keyword];
}
