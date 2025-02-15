import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../common/models/word.dart';

part 'preview_event.dart';
part 'preview_state.dart';

const kWordCountPerPage = 9;

class PreviewBloc extends Bloc<PreviewEvent, PreviewState> {
  PreviewBloc() : super(PreviewLoading()) {
    on<PreviewStarted>(_onStarted);
    on<PreviewPageChanged>(_onPageChanged);
  }

  _onStarted(PreviewStarted event, Emitter<PreviewState> emit) async {
    int pageCount = _caculatePageCount(event.words);
    emit(PreviewLoaded(
      words: event.words,
      pageCount: pageCount,
    ));
  }

  _onPageChanged(PreviewPageChanged event, Emitter<PreviewState> emit) async {
    final page = event.page;
    final theState = state as PreviewLoaded;
    emit(theState.copyWith(currentPage: page));
  }

  int _caculatePageCount(List<Word> words) {
    int wordCount = words.length;
    int pageCount = wordCount ~/ kWordCountPerPage;
    if (wordCount % kWordCountPerPage > 0) {
      pageCount++;
    }
    return pageCount;
  }
}
