part of 'grammar_bloc.dart';

sealed class GrammarState extends Equatable {
  const GrammarState();
}

final class GrammarLoading extends GrammarState {
  @override
  List<Object?> get props => [];
}

final class GrammarLoaded extends GrammarState {
  final Map<JLPTLevel, List<GrammarEntry>> entryMap;
  final GrammarItem currentItem;

  const GrammarLoaded({
    this.entryMap = const {},
    this.currentItem = GrammarItem.empty,
  });

  List<JLPTLevel> get levels => entryMap.keys.toList();

  @override
  List<Object?> get props => [entryMap, currentItem];

  GrammarLoaded copyWith({
    Map<JLPTLevel, List<GrammarEntry>>? entryMap,
    GrammarItem? currentItem,
  }) =>
      GrammarLoaded(
        entryMap: entryMap ?? this.entryMap,
        currentItem: currentItem ?? this.currentItem,
      );
}

final class GrammarError extends GrammarState {
  @override
  List<Object?> get props => [];
}
