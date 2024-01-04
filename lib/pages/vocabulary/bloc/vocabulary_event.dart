part of 'vocabulary_bloc.dart';

sealed class VocabularyEvent extends Equatable {
  const VocabularyEvent();

  @override
  List<Object> get props => [];
}

class VocabularyStarted extends VocabularyEvent {}

class VocabularyWordListStarted extends VocabularyEvent {
  final String key;
  const VocabularyWordListStarted({required this.key});
}
