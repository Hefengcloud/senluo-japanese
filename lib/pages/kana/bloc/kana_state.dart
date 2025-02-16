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

  const KanaLoaded({
    required this.kanaTable,
    required this.category,
    this.kana = Kana.empty,
  });

  get row => kanaTable[category]!.firstWhere((row) => row.contains(kana));

  get seion => kanaTable[KanaCategory.seion];

  get dakuon => kanaTable[KanaCategory.dakuon];

  get handakuon => kanaTable[KanaCategory.handakuon];

  get yoon => kanaTable[KanaCategory.yoon];

  KanaLoaded copyWith({
    Map<KanaCategory, List<KanaRow>>? kanaTable,
    KanaCategory? category,
    Kana? kana,
  }) =>
      KanaLoaded(
        kanaTable: kanaTable ?? this.kanaTable,
        category: category ?? this.category,
        kana: kana ?? this.kana,
      );

  @override
  List<Object> get props => [kanaTable, category, kana];
}
