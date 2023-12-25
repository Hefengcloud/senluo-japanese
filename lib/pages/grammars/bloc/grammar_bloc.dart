import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:senluo_japanese_cms/repos/grammars/grammar_repository.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

part 'grammar_event.dart';
part 'grammar_state.dart';

class GrammarBloc extends Bloc<GrammarEvent, GrammarState> {
  GrammarBloc({required this.grammarRepository}) : super(GrammarLoading()) {
    on<GrammarStarted>(_onStarted);
    on<GrammarItemSelected>(_onItemSelected);
    on<GrammarItemAdded>(_onItemAdded);
    on<GrammarItemDeleted>(_onItemDeleted);
  }

  final GrammarRepository grammarRepository;

  Future<void> _onStarted(
    GrammarStarted event,
    Emitter<GrammarState> emit,
  ) async {
    emit(GrammarLoading());

    try {
      final items = await grammarRepository.loadItems();
      if (items.isNotEmpty) {
        emit(GrammarLoaded(items: [...items], currentItem: items.first));
      } else {
        emit(const GrammarLoaded(items: []));
      }
    } catch (_) {
      emit(GrammarError());
    }
  }

  Future<void> _onItemSelected(
    GrammarItemSelected event,
    Emitter<GrammarState> emit,
  ) async {
    final state = this.state as GrammarLoaded;
    final item = await grammarRepository.loadItem(event.item.id);
    final newState = state.copyWith(currentItem: item);
    emit(newState);
  }

  Future<void> _onItemAdded(
    GrammarItemAdded event,
    Emitter<GrammarState> emit,
  ) async {
    await grammarRepository.addItem(event.item);

    final state = this.state as GrammarLoaded;
    final newState = state.copyWith(
      items: [...state.items, event.item],
      currentItem: event.item,
    );
    emit(newState);
  }

  Future<void> _onItemDeleted(
    GrammarItemDeleted event,
    Emitter<GrammarState> emit,
  ) async {
    final successful = await grammarRepository.delItem(event.item.id);
    if (successful) {
      add(GrammarStarted());
    }
  }
}
