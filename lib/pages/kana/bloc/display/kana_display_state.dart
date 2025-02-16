part of 'kana_display_bloc.dart';

sealed class KanaDisplayState extends Equatable {
  const KanaDisplayState();

  @override
  List<Object> get props => [];
}

final class KanaDisplayLoading extends KanaDisplayState {
  @override
  List<Object> get props => [];
}

final class KanaDisplayLoaded extends KanaDisplayState {
  final KanaRow row;
  final Kana initialKana;
  final KanaType type;
  final KanaCategory category;

  const KanaDisplayLoaded({
    required this.initialKana,
    required this.row,
    required this.type,
    required this.category,
  });

  Kana get leadingKana => row.first;

  bool get isHiragana => type == KanaType.hiragana;

  @override
  List<Object> get props => [initialKana, row, type, category];
}

final class KanaDisplayError extends KanaDisplayState {
  final String message;

  const KanaDisplayError(this.message);

  @override
  List<Object> get props => [message];
}
