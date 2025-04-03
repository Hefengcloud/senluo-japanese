import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
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
    final examples = item.examples
        .mapIndexed<Example>((index, e) => e.copyWith(isSelected: index < 1))
        .toList();
    emit(GrammarItemLoaded(item: item.copyWith(examples: examples)));
  }

  _onExampleSelected(
    GrammarExampleSelected event,
    Emitter<GrammarItemState> emit,
  ) async {
    if (state is! GrammarItemLoaded) return;

    final currentState = state as GrammarItemLoaded;
    final updatedExamples = currentState.item.examples.map<Example>((example) {
      if (example.jp == event.example.jp) {
        return example.copyWith(isSelected: !example.isSelected);
      }
      return example;
    }).toList();

    emit(GrammarItemLoaded(
      item: currentState.item.copyWith(examples: updatedExamples),
    ));
  }
}
