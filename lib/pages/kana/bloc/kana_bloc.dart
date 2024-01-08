import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:senluo_japanese_cms/repos/gojuon/kana_repository.dart';

import '../../../repos/gojuon/models/models.dart';

part 'kana_event.dart';
part 'kana_state.dart';

class KanaBloc extends Bloc<KanaEvent, KanaState> {
  final KanaRepository kanaRepo;
  KanaBloc({required this.kanaRepo}) : super(KanaLoading()) {
    on<KanaStarted>(_onStarted);
    on<KanaCategoryChanged>(_onCategoryChanged);
  }

  _onStarted(
    KanaStarted event,
    Emitter<KanaState> emit,
  ) async {
    emit(KanaLoading());
    final kanaTable = await kanaRepo.loadKanaTable();
    emit(KanaLoaded(
      kanaTable: kanaTable,
      currentKanaType: KanaCategory.seion,
    ));
  }

  _onCategoryChanged(
    KanaCategoryChanged event,
    Emitter<KanaState> emit,
  ) async {
    final theState = state as KanaLoaded;
    emit(
      KanaLoaded(
        kanaTable: theState.kanaTable,
        currentKanaType: event.category,
      ),
    );
  }
}
