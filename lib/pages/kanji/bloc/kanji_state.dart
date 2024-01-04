part of 'kanji_bloc.dart';

sealed class KanjiState extends Equatable {
  const KanjiState();

  @override
  List<Object?> get props => [];
}

final class KanjiLoading extends KanjiState {}

final class KanjiLoaded extends KanjiState {
  final JLPTLevel jlptLevel;
  final List<Kanji> kanjis;

  const KanjiLoaded({required this.kanjis, required this.jlptLevel});

  @override
  List<Object?> get props => [kanjis, jlptLevel];
}
