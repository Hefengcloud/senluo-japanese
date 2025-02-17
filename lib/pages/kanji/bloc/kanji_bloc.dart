import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';
import 'package:senluo_japanese_cms/repos/kanji/kanji_repository.dart';

import '../../../repos/kanji/models/kanji_model.dart';

part 'kanji_event.dart';
part 'kanji_state.dart';

class KanjiBloc extends Bloc<KanjiEvent, KanjiState> {
  final KanjiRepository kanjiRepository;

  KanjiBloc(this.kanjiRepository) : super(KanjiLoading()) {
    on<KanjiStarted>(_onStarted);
    on<KanjiLevelChanged>(_onLevelChanged);
    on<KanjiDetailStarted>(_onDetailStarted);
    on<KanjiDetailChanged>(_onDetailChanged);
  }

  _onStarted(KanjiStarted event, Emitter<KanjiState> emit) async {
    emit(const KanjiLoaded(kanjis: [], jlptLevel: JLPTLevel.none));
  }

  _onLevelChanged(KanjiLevelChanged event, Emitter<KanjiState> emit) async {
    final level = event.level;
    final kanjis = await kanjiRepository.loadJlptKanjis(level);
    emit(KanjiLoaded(kanjis: kanjis, jlptLevel: level));
  }

  _onDetailStarted(KanjiDetailStarted event, Emitter<KanjiState> emit) async {
    final detail = await kanjiRepository.loadKanjiDetail(event.kanji);
    emit((state as KanjiLoaded).copyWith(currentKanjiDetail: detail));
  }

  _onDetailChanged(KanjiDetailChanged event, Emitter<KanjiState> emit) async {
    final theState = state as KanjiLoaded;
    var index = theState.kanjis
        .indexWhere((kanji) => kanji.key == theState.currentKanjiDetail.key);
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

    final kanjiDetail = await kanjiRepository.loadKanjiDetail(kanji);

    emit(theState.copyWith(currentKanjiDetail: kanjiDetail));
  }
}
