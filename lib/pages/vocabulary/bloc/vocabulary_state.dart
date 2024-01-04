part of 'vocabulary_bloc.dart';

sealed class VocabularyState extends Equatable {
  const VocabularyState();

  @override
  List<Object> get props => [];
}

final class VocabularyLoading extends VocabularyState {}

final class VocabularyLoaded extends VocabularyState {
  final Map<VocabularyType, List<VocabularyMenu>> type2Menus;
  final List<Word> wordList;

  const VocabularyLoaded({
    required this.type2Menus,
    required this.wordList,
  });
}
