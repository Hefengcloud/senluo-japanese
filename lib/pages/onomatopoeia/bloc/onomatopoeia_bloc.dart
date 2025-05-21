import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:senluo_onomatopoeia/senluo_onomatopoeia.dart';

part 'onomatopoeia_event.dart';
part 'onomatopoeia_state.dart';

class OnomatopoeiaBloc extends Bloc<OnomatopoeiaEvent, OnomatopoeiaState> {
  final OnomatopoeiaRepository repo;

  OnomatopoeiaBloc(this.repo) : super(OnomatopoeiaLoading()) {
    on<OnomatopoeiaStarted>(_onStarted);
    on<OnomatopoeiaFiltered>(_onFiltered);
  }

  _onStarted(
    OnomatopoeiaStarted event,
    Emitter<OnomatopoeiaState> emit,
  ) async {
    emit(OnomatopoeiaLoading());
    final categories = await repo.loadCategories();
    final items = await repo.loadItems();
    emit(OnomatopoeiaLoaded(
      items: items,
      categories: categories,
      currentCategory: OnomatopoeiaCategory.empty,
    ));
  }

  _onFiltered(
    OnomatopoeiaFiltered event,
    Emitter<OnomatopoeiaState> emit,
  ) async {
    final theState = state as OnomatopoeiaLoaded;
    var items = theState.items;
    if (event.category == OnomatopoeiaCategory.empty) {
      items = await repo.loadItems();
    } else {
      items = await repo.loadCategoryItems(event.category);
    }
    emit(OnomatopoeiaLoaded(
      items: items,
      currentCategory: event.category,
      categories: theState.categories,
    ));
  }
}
