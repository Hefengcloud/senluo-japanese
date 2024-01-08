part of 'kana_bloc.dart';

sealed class KanaEvent extends Equatable {
  const KanaEvent();

  @override
  List<Object> get props => [];
}

final class KanaStarted extends KanaEvent {}

final class KanaCategoryChanged extends KanaEvent {
  final KanaCategory category;

  const KanaCategoryChanged({required this.category});
}
