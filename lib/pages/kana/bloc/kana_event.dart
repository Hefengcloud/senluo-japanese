part of 'kana_bloc.dart';

sealed class KanaEvent extends Equatable {
  const KanaEvent();

  @override
  List<Object> get props => [];
}

final class KanaStarted extends KanaEvent {
  final KanaCategory category;

  const KanaStarted({this.category = KanaCategory.seion});
}

final class KanaCategoryChanged extends KanaEvent {
  final KanaCategory category;

  const KanaCategoryChanged({required this.category});
}

final class KanaSelected extends KanaEvent {
  final KanaCategory category;
  final Kana kana;

  const KanaSelected({
    required this.category,
    required this.kana,
  });
}

final class KanaChanged extends KanaEvent {
  final bool isNext;

  const KanaChanged({required this.isNext});
}
