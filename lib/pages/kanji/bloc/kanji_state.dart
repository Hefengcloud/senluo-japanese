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
  final KanjiDetail currentKanjiDetail;

  const KanjiLoaded({
    required this.kanjis,
    required this.jlptLevel,
    this.currentKanjiDetail = KanjiDetail.empty,
  });

  KanjiLoaded copyWith({
    JLPTLevel? jlptLevel,
    List<Kanji>? kanjis,
    KanjiDetail? currentKanjiDetail,
  }) {
    return KanjiLoaded(
      kanjis: kanjis ?? this.kanjis,
      jlptLevel: jlptLevel ?? this.jlptLevel,
      currentKanjiDetail: currentKanjiDetail ?? this.currentKanjiDetail,
    );
  }

  @override
  List<Object?> get props => [kanjis, jlptLevel, currentKanjiDetail];
}
