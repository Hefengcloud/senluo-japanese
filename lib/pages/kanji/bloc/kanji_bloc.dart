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
  }

  _onStarted(KanjiStarted event, Emitter<KanjiState> emit) async {
    final kanjis = await kanjiRepository.loadJlptKanjis(JLPTLevel.n1);
    emit(KanjiLoaded(kanjis: kanjis, jlptLevel: JLPTLevel.n1));
  }

  _onLevelChanged(KanjiLevelChanged event, Emitter<KanjiState> emit) async {
    final level = event.level;
    final kanjis = await kanjiRepository.loadJlptKanjis(level);
    emit(KanjiLoaded(kanjis: kanjis, jlptLevel: level));
  }
}
