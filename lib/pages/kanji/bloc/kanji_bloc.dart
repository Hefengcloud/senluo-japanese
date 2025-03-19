import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:senluo_common/senluo_common.dart';
import 'package:senluo_japanese_cms/repos/kanji/kanji_repository.dart';

import '../../../repos/kanji/models/kanji_model.dart';

part 'kanji_event.dart';
part 'kanji_state.dart';

class KanjiBloc extends Bloc<KanjiEvent, KanjiState> {
  final KanjiRepository kanjiRepository;

  KanjiBloc(this.kanjiRepository) : super(KanjiLoading()) {
    on<KanjiStarted>(_onStarted);
    on<KanjiLevelChanged>(_onLevelChanged);
    on<KanjiIndexChanged>(_onIndexChanged);
    on<KanjiDetailStarted>(_onDetailStarted);
    on<KanjiDetailRequested>(_onDetailChanged);
  }

  _onStarted(KanjiStarted event, Emitter<KanjiState> emit) async {
    emit(const KanjiLoaded(kanjis: [], jlptLevel: JLPTLevel.none));
  }

  _onLevelChanged(KanjiLevelChanged event, Emitter<KanjiState> emit) async {
    final level = event.level;
    final kanjis = await kanjiRepository.loadJlptKanjis(level);
    emit(KanjiLoaded(kanjis: kanjis, jlptLevel: level));
  }

  _onIndexChanged(KanjiIndexChanged event, Emitter<KanjiState> emit) async {
    final theState = state as KanjiLoaded;

    final index = event.index;
    final kanji = theState.kanjis[index];

    final detail = await kanjiRepository.loadKanjiDetail(kanji);
    emit(theState.copyWith(currentDetail: detail, currentIndex: index));
  }

  _onDetailStarted(KanjiDetailStarted event, Emitter<KanjiState> emit) async {
    final kanji = (state as KanjiLoaded).kanjis[event.index];
    final detail = await kanjiRepository.loadKanjiDetail(kanji);
    emit((state as KanjiLoaded).copyWith(
      currentDetail: detail,
      currentIndex: event.index,
    ));
  }

  _onDetailChanged(KanjiDetailRequested event, Emitter<KanjiState> emit) async {
    final theState = state as KanjiLoaded;
    var index = theState.kanjis
        .indexWhere((kanji) => kanji.key == theState.currentDetail.key);
    if (event.previous) {
      index = index - 1;
      if (index <= 0) {
        index = theState.kanjis.length - 1;
      }
    } else {
      index = index + 1;
      if (index > theState.kanjis.length - 1) {
        index = 0;
      }
    }

    final kanji = theState.kanjis[index];

    final detail = await kanjiRepository.loadKanjiDetail(kanji);

    emit(theState.copyWith(
      currentDetail: detail,
      currentIndex: index,
    ));
  }
}
