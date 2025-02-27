part of 'zengo_bloc.dart';

sealed class ZengoState extends Equatable {
  const ZengoState();

  @override
  List<Object> get props => [];
}

final class ZengoLoading extends ZengoState {}

final class ZengoLoaded extends ZengoState {
  final List<Zengo> items;
  final Zengo currentItem;

  const ZengoLoaded({
    required this.items,
    this.currentItem = Zengo.empty,
  });

  int get currentIndex => items.indexOf(currentItem);

  ZengoLoaded copyWith({
    List<Zengo>? items,
    Zengo? currentItem,
  }) =>
      ZengoLoaded(
        items: items ?? this.items,
        currentItem: currentItem ?? this.currentItem,
      );
}
