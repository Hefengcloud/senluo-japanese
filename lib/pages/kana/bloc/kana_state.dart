part of 'kana_bloc.dart';

sealed class KanaState extends Equatable {
  const KanaState();

  @override
  List<Object> get props => [];
}

final class KanaLoading extends KanaState {}

final class KanaLoaded extends KanaState {
  final Map<KanaCategory, List<KanaRow>> kanaTable;
  final KanaCategory currentKanaType;

  const KanaLoaded({
    required this.kanaTable,
    required this.currentKanaType,
  });

  List<KanaRow> currentKanaRows() {
    if (currentKanaType == KanaCategory.dakuon) {
      return [
        ...(kanaTable[KanaCategory.dakuon] ?? []),
        ...(kanaTable[KanaCategory.handakuon] ?? []),
      ];
    }
    return kanaTable[currentKanaType] ?? [];
  }

  @override
  List<Object> get props => [kanaTable, currentKanaType];
}
