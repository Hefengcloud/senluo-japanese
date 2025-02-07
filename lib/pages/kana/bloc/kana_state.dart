part of 'kana_bloc.dart';

sealed class KanaState extends Equatable {
  const KanaState();

  @override
  List<Object> get props => [];
}

final class KanaLoading extends KanaState {}

final class KanaLoaded extends KanaState {
  final Map<KanaCategory, List<KanaRow>> kanaTable;

  const KanaLoaded({
    required this.kanaTable,
  });

  get seion => kanaTable[KanaCategory.seion];

  get dakuon => kanaTable[KanaCategory.dakuon];

  get handakuon => kanaTable[KanaCategory.handakuon];

  get yoon => kanaTable[KanaCategory.yoon];

  @override
  List<Object> get props => [kanaTable];
}
