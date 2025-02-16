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
    on<KanaSelected>(_onKanaSelected);
    on<KanaChanged>(_onKanaChanged);
  }

  _onStarted(
    KanaStarted event,
    Emitter<KanaState> emit,
  ) async {
    emit(KanaLoading());
    final kanaTable = await kanaRepo.loadKanaTable();
    emit(KanaLoaded(kanaTable: kanaTable, category: event.category));
  }

  _onKanaSelected(
    KanaSelected event,
    Emitter<KanaState> emit,
  ) async {
    final theState = state as KanaLoaded;
    emit(theState.copyWith(kana: event.kana));
  }

  _onKanaChanged(
    KanaChanged event,
    Emitter<KanaState> emit,
  ) async {
    final theState = state as KanaLoaded;
    final row = theState.row;
    final kanaTable = theState.kanaTable[theState.category]!;

    final kanaIndex = row.indexOf(theState.kana);

    if (event.isNext) {
      if (kanaIndex < row.length - 1) {
        final nextKana = row[kanaIndex + 1];
        emit(theState.copyWith(kana: nextKana));
      } else if (kanaIndex == row.length - 1) {
        final currentRowIndex =
            kanaTable.indexWhere((row) => row.contains(theState.kana));
        if (currentRowIndex < kanaTable.length - 1) {
          final nextRow = kanaTable[currentRowIndex + 1];
          emit(theState.copyWith(kana: nextRow.first));
        }
      }
    } else {
      if (kanaIndex > 0) {
        final prevKana = row[kanaIndex - 1];
        emit(theState.copyWith(kana: prevKana));
      } else if (kanaIndex == 0) {
        final currentRowIndex =
            kanaTable.indexWhere((row) => row.contains(theState.kana));
        if (currentRowIndex > 0) {
          final prevRow = kanaTable[currentRowIndex - 1];
          emit(theState.copyWith(kana: prevRow.last));
        }
      }
    }
  }
}
