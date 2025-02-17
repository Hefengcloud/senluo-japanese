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

  final int currentIndex;
  final KanjiDetail currentDetail;

  const KanjiLoaded({
    required this.kanjis,
    required this.jlptLevel,
    this.currentIndex = -1,
    this.currentDetail = KanjiDetail.empty,
  });

  KanjiLoaded copyWith({
    JLPTLevel? jlptLevel,
    List<Kanji>? kanjis,
    int? currentIndex,
    KanjiDetail? currentDetail,
  }) {
    return KanjiLoaded(
      kanjis: kanjis ?? this.kanjis,
      jlptLevel: jlptLevel ?? this.jlptLevel,
      currentIndex: currentIndex ?? this.currentIndex,
      currentDetail: currentDetail ?? this.currentDetail,
    );
  }

  @override
  List<Object?> get props => [kanjis, jlptLevel, currentDetail];
}
