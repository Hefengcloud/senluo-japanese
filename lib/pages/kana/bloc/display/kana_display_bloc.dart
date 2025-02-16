import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:senluo_japanese_cms/repos/gojuon/models/models.dart';

import '../../../../repos/gojuon/kana_repository.dart';

part 'kana_display_event.dart';
part 'kana_display_state.dart';

class KanaDisplayBloc extends Bloc<KanaDisplayEvent, KanaDisplayState> {
  final KanaRepository kanaRepository;
  KanaDisplayBloc(this.kanaRepository) : super(KanaDisplayLoading()) {
    on<KanaDisplayStarted>(_onKanaDisplayStarted);
    on<KanaDisplayRowChanged>(_onKanaDisplayRowChanged);
  }

  _onKanaDisplayStarted(
    KanaDisplayStarted event,
    Emitter<KanaDisplayState> emit,
  ) async {
    emit(KanaDisplayLoading());
    try {
      final row = await kanaRepository.loadKanaRow(event.kana, event.category);
      emit(KanaDisplayLoaded(
        kana: event.kana,
        row: row,
        type: event.type,
        category: event.category,
      ));
    } catch (e) {
      emit(KanaDisplayError(e.toString()));
    }
  }

  _onKanaDisplayRowChanged(
    KanaDisplayRowChanged event,
    Emitter<KanaDisplayState> emit,
  ) async {
    final isNext = event.isNext;
    final theState = state as KanaDisplayLoaded;
    try {
      if (isNext) {
        final row = await kanaRepository.loadNextKanaRow(
          theState.kana,
          theState.category,
        );
        emit(KanaDisplayLoaded(
          kana: row.first,
          row: row,
          type: theState.type,
          category: theState.category,
        ));
      } else {
        final row = await kanaRepository.loadPreviousKanaRow(
          theState.kana,
          theState.category,
        );
        emit(KanaDisplayLoaded(
          kana: row.first,
          row: row,
          type: theState.type,
          category: theState.category,
        ));
      }
    } catch (e) {
      emit(KanaDisplayError(e.toString()));
    }
  }
}
