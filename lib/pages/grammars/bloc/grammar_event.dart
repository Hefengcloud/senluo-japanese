part of 'grammar_bloc.dart';

sealed class GrammarEvent extends Equatable {
  const GrammarEvent();
}

class GrammarStarted extends GrammarEvent {
  @override
  List<Object?> get props => [];
}

class GrammarEntryChanged extends GrammarEvent {
  final GrammarEntry entry;

  const GrammarEntryChanged({
    required this.entry,
  });

  @override
  List<Object> get props => [entry];
}

class GrammarKeywordChanged extends GrammarEvent {
  final String? keyword;

  const GrammarKeywordChanged({
    required this.keyword,
  });

  @override
  List<Object?> get props => [keyword];
}

class GrammarItemAdded extends GrammarEvent {
  final GrammarItem item;

  const GrammarItemAdded({required this.item});

  @override
  List<Object?> get props => [item];
}

class GrammarItemSelected extends GrammarEvent {
  final GrammarItem item;

  const GrammarItemSelected({required this.item});

  @override
  List<Object?> get props => [item];
}

class GrammarItemDeleted extends GrammarEvent {
  final GrammarItem item;

  const GrammarItemDeleted({required this.item});

  @override
  List<Object?> get props => [item];
}
