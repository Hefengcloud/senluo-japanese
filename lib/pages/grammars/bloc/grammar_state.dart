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
  final JLPTLevel currentLevel;
  final GrammarItem currentItem;

  const GrammarLoaded({
    this.entryMap = const {},
    this.currentLevel = JLPTLevel.none,
    this.currentItem = GrammarItem.empty,
  });

  int get currentItemIndex => entryMap[currentItem.level]!
      .indexWhere((entry) => entry.key == currentItem.key);

  List<GrammarEntry> get currentLevelEntries => entryMap[currentLevel] ?? [];

  @override
  List<Object?> get props => [entryMap, currentItem, currentLevel];

  GrammarLoaded copyWith({
    Map<JLPTLevel, List<GrammarEntry>>? entryMap,
    GrammarItem? currentItem,
    JLPTLevel? currentLevel,
  }) =>
      GrammarLoaded(
        entryMap: entryMap ?? this.entryMap,
        currentItem: currentItem ?? this.currentItem,
        currentLevel: currentLevel ?? this.currentLevel,
      );
}
