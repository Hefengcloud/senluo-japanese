part of 'onomatopoeia_bloc.dart';

sealed class OnomatopoeiaState extends Equatable {
  const OnomatopoeiaState();

  @override
  List<Object> get props => [];
}

final class OnomatopoeiaLoading extends OnomatopoeiaState {}

final class OnomatopoeiaLoaded extends OnomatopoeiaState {
  final List<OnomatopoeiaCategory> categories;
  final List<Onomatopoeia> items;
  final OnomatopoeiaCategory currentCategory;

  const OnomatopoeiaLoaded({
    required this.items,
    required this.categories,
    required this.currentCategory,
  });

  @override
  List<Object> get props => [items, categories, currentCategory];
}
