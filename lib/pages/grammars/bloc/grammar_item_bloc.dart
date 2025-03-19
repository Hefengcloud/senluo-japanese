import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:senluo_bunpo/senluo_bunpo.dart';

part 'grammar_item_event.dart';
part 'grammar_item_state.dart';

class GrammarItemBloc extends Bloc<GrammarItemEvent, GrammarItemState> {
  final GrammarRepository repo;
  GrammarItemBloc(this.repo) : super(GrammarItemLoading()) {
    on<GrammarItemStarted>(_onStarted);
    on<GrammarExampleSelected>(_onExampleSelected);
  }

  _onStarted(GrammarItemStarted event, Emitter<GrammarItemState> emit) async {
    final item = event.item;

    final displayedItem = item.copyWith(
      examples: List.from(item.examples.take(1)),
    );
    emit(GrammarItemLoaded(item: item, displayedItem: displayedItem));
  }

  _onExampleSelected(
    GrammarExampleSelected event,
    Emitter<GrammarItemState> emit,
  ) async {
    final theState = state as GrammarItemLoaded;
    final examples = List<Example>.from(theState.displayedItem.examples);
    if (examples.contains(event.example)) {
      examples.remove(event.example);
    } else {
      examples.add(event.example);
    }
    final displayedItem = theState.displayedItem.copyWith(examples: examples);
    emit(GrammarItemLoaded(
      item: theState.item,
      displayedItem: displayedItem,
    ));
  }
}
