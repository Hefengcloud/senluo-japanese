part of 'zengo_bloc.dart';

sealed class ZengoEvent extends Equatable {
  const ZengoEvent();
}

class ZengoItemChanged extends ZengoEvent {
  final Zengo item;

  const ZengoItemChanged({required this.item});

  @override
  List<Object?> get props => [item];
}
