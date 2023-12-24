part of 'proverb_bloc.dart';

sealed class ProverbState extends Equatable {
  const ProverbState();

  @override
  List<Object> get props => [];
}

final class ProverbLoading extends ProverbState {}

final class ProverbLoaded extends ProverbState {
  final List<ProverbItem> items;

  const ProverbLoaded({required this.items});
}

final class ProverbError extends ProverbState {}
