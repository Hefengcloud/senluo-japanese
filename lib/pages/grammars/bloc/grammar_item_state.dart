part of 'grammar_item_bloc.dart';

sealed class GrammarItemState extends Equatable {
  const GrammarItemState();

  @override
  List<Object> get props => [];
}

final class GrammarItemLoading extends GrammarItemState {}

final class GrammarItemLoaded extends GrammarItemState {
  final GrammarItem item;
  final GrammarItem displayedItem;

  const GrammarItemLoaded({
    required this.item,
    required this.displayedItem,
  });

  @override
  List<Object> get props => [item, displayedItem];
}
