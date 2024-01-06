part of 'grammar_item_bloc.dart';

sealed class GrammarItemEvent extends Equatable {
  const GrammarItemEvent();

  @override
  List<Object> get props => [];
}

final class GrammarItemStarted extends GrammarItemEvent {
  final GrammarEntry entry;

  const GrammarItemStarted({required this.entry});

  @override
  List<Object> get props => [entry];
}

final class GrammarExampleSelected extends GrammarItemEvent {
  final Example example;

  const GrammarExampleSelected({required this.example});

  @override
  List<Object> get props => [example];
}
