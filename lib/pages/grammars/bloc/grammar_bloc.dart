import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';
import 'package:senluo_japanese_cms/repos/grammars/grammar_repository.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_entry.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

part 'grammar_event.dart';
part 'grammar_state.dart';

class GrammarBloc extends Bloc<GrammarEvent, GrammarState> {
  GrammarBloc({required this.grammarRepository}) : super(GrammarLoading()) {
    on<GrammarStarted>(_onStarted);
    on<GrammarLevelChanged>(_onLevelChanged);
  }

  final GrammarRepository grammarRepository;

  Future<void> _onStarted(
    GrammarStarted event,
    Emitter<GrammarState> emit,
  ) async {
    emit(GrammarLoading());

    // try {
    //   final items = await grammarRepository.loadItems();
    //   if (items.isNotEmpty) {
    //     emit(GrammarLoaded(items: [...items], currentItem: items.first));
    //   } else {
    //     emit(const GrammarLoaded(items: []));
    //   }
    // } catch (_) {
    //   emit(GrammarError());
    // }

    final level2entries = await grammarRepository.loadEntries();
    emit(GrammarLoaded(entryMap: level2entries));
  }

  Future<void> _onLevelChanged(
    GrammarLevelChanged event,
    Emitter<GrammarState> emit,
  ) async {
    final theState = state as GrammarLoaded;
    emit(theState.copyWith(currentLevel: event.level));
  }
}
