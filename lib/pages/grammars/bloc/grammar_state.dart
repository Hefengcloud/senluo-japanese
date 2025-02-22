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

  int get currentIndex => entryMap[currentItem.level]!
      .indexWhere((entry) => entry.key == currentItem.key);

  List<JLPTLevel> get levels => entryMap.keys.toList();

  List<GrammarEntry> get entries => entryMap[currentItem.level]!;

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
