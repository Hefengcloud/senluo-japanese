part of 'kana_display_bloc.dart';

sealed class KanaDisplayEvent extends Equatable {
  const KanaDisplayEvent();

  @override
  List<Object> get props => [];
}

class KanaDisplayStarted extends KanaDisplayEvent {
  final Kana kana;
  final KanaType type;
  final KanaCategory category;

  const KanaDisplayStarted({
    required this.kana,
    required this.type,
    required this.category,
  });

  @override
  List<Object> get props => [kana, type, category];
}
