part of 'grammar_bloc.dart';

@immutable
sealed class GrammarEvent extends Equatable {
  const GrammarEvent();
}

class GrammarStarted extends GrammarEvent {
  @override
  List<Object?> get props => [];
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
