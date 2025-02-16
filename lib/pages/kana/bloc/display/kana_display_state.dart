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
  final Kana kana;
  final KanaType type;

  const KanaDisplayLoaded({
    required this.kana,
    required this.row,
    required this.type,
  });

  @override
  List<Object> get props => [kana, row, type];
}

final class KanaDisplayError extends KanaDisplayState {
  final String message;

  const KanaDisplayError(this.message);

  @override
  List<Object> get props => [message];
}
