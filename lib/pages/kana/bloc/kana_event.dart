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

final class KanaTypeChanged extends KanaEvent {
  final KanaType type;

  const KanaTypeChanged({required this.type});
}
