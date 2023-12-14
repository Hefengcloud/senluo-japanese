part of 'grammar_bloc.dart';

@immutable
sealed class GrammarState extends Equatable {
  const GrammarState();
}

final class GrammarLoading extends GrammarState {
  @override
  List<Object?> get props => [];
}

final class GrammarLoaded extends GrammarState {
  final List<GrammarItem> items;
  final GrammarItem currentItem;

  const GrammarLoaded({
    this.items = const [],
    this.currentItem = GrammarItem.empty,
  });

  @override
  List<Object?> get props => [currentItem];
}

final class GrammarError extends GrammarState {
  @override
  List<Object?> get props => [];
}
