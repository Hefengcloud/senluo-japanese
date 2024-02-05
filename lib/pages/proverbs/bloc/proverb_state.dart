part of 'proverb_bloc.dart';

sealed class ProverbState extends Equatable {
  const ProverbState();

  @override
  List<Object> get props => [];
}

final class ProverbLoading extends ProverbState {}

final class ProverbLoaded extends ProverbState {
  final List<ProverbItem> items;
  final ProverbItem currentItem;
  final KanaLine currentKanaLine;

  const ProverbLoaded({
    required this.items,
    this.currentItem = ProverbItem.empty,
    this.currentKanaLine = KanaLine.none,
  });

  ProverbLoaded copyWith({
    List<ProverbItem>? items,
    ProverbItem? currentItem,
    KanaLine? currentKanaLine,
  }) {
    return ProverbLoaded(
      items: items ?? this.items,
      currentItem: currentItem ?? this.currentItem,
      currentKanaLine: currentKanaLine ?? this.currentKanaLine,
    );
  }

  @override
  List<Object> get props => [items, currentItem, currentKanaLine];
}

final class ProverbError extends ProverbState {}
