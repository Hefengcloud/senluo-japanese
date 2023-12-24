part of 'proverb_bloc.dart';

sealed class ProverbEvent extends Equatable {
  const ProverbEvent();

  @override
  List<Object> get props => [];
}

final class ProverbStarted extends ProverbEvent {}
