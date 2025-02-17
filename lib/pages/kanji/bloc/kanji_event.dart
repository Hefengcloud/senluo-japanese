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

class KanjiDetailStarted extends KanjiEvent {
  final int index;

  const KanjiDetailStarted({required this.index});
}

class KanjiIndexChanged extends KanjiEvent {
  final int index;

  const KanjiIndexChanged({required this.index});
}

class KanjiDetailRequested extends KanjiEvent {
  final bool previous;

  const KanjiDetailRequested({required this.previous});
}
