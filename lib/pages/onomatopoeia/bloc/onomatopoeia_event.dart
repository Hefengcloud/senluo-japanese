part of 'onomatopoeia_bloc.dart';

sealed class OnomatopoeiaEvent extends Equatable {
  const OnomatopoeiaEvent();

  @override
  List<Object> get props => [];
}

class OnomatopoeiaStarted extends OnomatopoeiaEvent {}

class OnomatopoeiaFiltered extends OnomatopoeiaEvent {
  final OnomatopoeiaCategory category;

  const OnomatopoeiaFiltered({this.category = OnomatopoeiaCategory.empty});
}
