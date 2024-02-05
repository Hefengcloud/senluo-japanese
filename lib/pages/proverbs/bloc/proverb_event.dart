part of 'proverb_bloc.dart';

sealed class ProverbEvent extends Equatable {
  const ProverbEvent();

  @override
  List<Object> get props => [];
}

final class ProverbStarted extends ProverbEvent {}

final class ProverbSearched extends ProverbEvent {
  final String keyword;

  const ProverbSearched({required this.keyword});
}

final class ProverbFiltered extends ProverbEvent {
  final KanaLine kanaLine;

  const ProverbFiltered({required this.kanaLine});
}

final class ProverbSelected extends ProverbEvent {
  final ProverbItem item;

  const ProverbSelected({required this.item});
}

final class ProverbChanged extends ProverbEvent {
  final bool next;

  const ProverbChanged({required this.next});
}
