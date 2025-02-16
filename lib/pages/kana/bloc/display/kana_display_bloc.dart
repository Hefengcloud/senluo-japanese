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
  }

  _onKanaDisplayStarted(
    KanaDisplayStarted event,
    Emitter<KanaDisplayState> emit,
  ) async {
    emit(KanaDisplayLoading());
    try {
      final row = await kanaRepository.loadKanaRow(event.kana, event.category);
      emit(KanaDisplayLoaded(kana: event.kana, row: row, type: event.type));
    } catch (e) {
      emit(KanaDisplayError(e.toString()));
    }
  }
}
