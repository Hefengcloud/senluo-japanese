part of 'grammar_item_bloc.dart';

sealed class GrammarItemEvent extends Equatable {
  const GrammarItemEvent();

  @override
  List<Object> get props => [];
}

final class GrammarItemStarted extends GrammarItemEvent {
  final GrammarItem item;

  const GrammarItemStarted({required this.item});

  @override
  List<Object> get props => [item];
}

final class GrammarExampleSelected extends GrammarItemEvent {
  final Example example;

  const GrammarExampleSelected({required this.example});

  @override
  List<Object> get props => [example];
}
