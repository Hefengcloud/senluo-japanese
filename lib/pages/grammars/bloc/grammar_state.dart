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
  final String? level;
  final String? keyword;

  const GrammarLoaded({
    this.items = const [],
    this.currentItem = GrammarItem.empty,
    this.level,
    this.keyword,
  });

  @override
  List<Object?> get props => [items, currentItem, level, keyword];

  GrammarLoaded copyWith({
    GrammarItem? currentItem,
    List<GrammarItem>? items,
  }) =>
      GrammarLoaded(
        currentItem: currentItem ?? this.currentItem,
        items: items ?? this.items,
      );
}

final class GrammarError extends GrammarState {
  @override
  List<Object?> get props => [];
}
