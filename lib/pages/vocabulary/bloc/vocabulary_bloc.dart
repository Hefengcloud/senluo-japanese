import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:senluo_japanese_cms/repos/vocabulary/models/vocabulary_menu.dart';
import 'package:senluo_japanese_cms/repos/vocabulary/vocabulary_repository.dart';

import '../../../common/models/word.dart';

part 'vocabulary_event.dart';
part 'vocabulary_state.dart';

class VocabularyBloc extends Bloc<VocabularyEvent, VocabularyState> {
  final VocabularyRepository repo;

  VocabularyBloc(this.repo) : super(VocabularyLoading()) {
    on<VocabularyStarted>(_onStarted);
    on<VocabularyWordListStarted>(_onWordListStarted);
  }

  _onStarted(
    VocabularyStarted event,
    Emitter<VocabularyState> emit,
  ) async {
    final menus = await repo.loadMenus(VocabularyType.category);
    final type2Menus = {
      VocabularyType.category: menus,
    };
    emit(VocabularyLoaded(type2Menus: type2Menus, wordList: const []));
  }

  _onWordListStarted(
    VocabularyWordListStarted event,
    Emitter<VocabularyState> emit,
  ) async {
    final theState = state as VocabularyLoaded;
    try {
      final words = await repo.loadWords(event.key);
      emit(VocabularyLoaded(
        type2Menus: theState.type2Menus,
        wordList: words,
      ));
    } catch (e) {
      print(e);
    }
  }
}
