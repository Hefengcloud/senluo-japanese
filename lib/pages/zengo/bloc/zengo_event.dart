part of 'zengo_bloc.dart';

sealed class ZengoEvent extends Equatable {
  const ZengoEvent();
}

class ZengoStarted extends ZengoEvent {
  @override
  List<Object?> get props => [];
}

class ZengoItemChanged extends ZengoEvent {
  final Zengo item;

  const ZengoItemChanged({required this.item});

  @override
  List<Object?> get props => [item];
}

class ZengoIndexChanged extends ZengoEvent {
  final int index;

  const ZengoIndexChanged({required this.index});

  @override
  List<Object?> get props => [index];
}
