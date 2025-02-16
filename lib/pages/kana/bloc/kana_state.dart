part of 'kana_bloc.dart';

sealed class KanaState extends Equatable {
  const KanaState();

  @override
  List<Object> get props => [];
}

final class KanaLoading extends KanaState {}

final class KanaLoaded extends KanaState {
  final Map<KanaCategory, List<KanaRow>> kanaTable;
  final KanaCategory category;
  final Kana kana;
  final KanaType type;

  const KanaLoaded({
    required this.kanaTable,
    required this.category,
    this.type = KanaType.all,
    this.kana = Kana.empty,
  });

  get seion => kanaTable[KanaCategory.seion];

  get dakuon => kanaTable[KanaCategory.dakuon];

  get yoon => kanaTable[KanaCategory.yoon];

  KanaLoaded copyWith({
    Map<KanaCategory, List<KanaRow>>? kanaTable,
    KanaCategory? category,
    Kana? kana,
    KanaType? type,
  }) =>
      KanaLoaded(
        kanaTable: kanaTable ?? this.kanaTable,
        category: category ?? this.category,
        kana: kana ?? this.kana,
        type: type ?? this.type,
      );

  @override
  List<Object> get props => [kanaTable, category, kana, type];
}
