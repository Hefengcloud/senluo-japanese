part of 'kanji_bloc.dart';

sealed class KanjiEvent extends Equatable {
  const KanjiEvent();

  @override
  List<Object> get props => [];
}

class KanjiStarted extends KanjiEvent {}

class KanjiLevelChanged extends KanjiEvent {
  final JLPTLevel level;

  const KanjiLevelChanged(this.level);
}
