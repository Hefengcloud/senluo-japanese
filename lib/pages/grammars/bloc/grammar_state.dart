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
  final Map<String, List<GrammarEntry>> entryMap;
  final String currentLevel;

  const GrammarLoaded({
    this.entryMap = const {},
    this.currentLevel = '',
  });

  List<String> get levels => entryMap.keys.toList();

  List<GrammarEntry> get entries => entryMap[currentLevel] ?? [];

  @override
  List<Object?> get props => [entryMap, currentLevel];

  GrammarLoaded copyWith({
    Map<String, List<GrammarEntry>>? entryMap,
    String? currentLevel,
  }) =>
      GrammarLoaded(
        entryMap: entryMap ?? this.entryMap,
        currentLevel: currentLevel ?? this.currentLevel,
      );
}

final class GrammarError extends GrammarState {
  @override
  List<Object?> get props => [];
}
