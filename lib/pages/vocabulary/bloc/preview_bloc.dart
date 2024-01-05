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
    on<PreviewGroupChanged>(_onGroupChanged);
    on<PreviewPageChanged>(_onPageChanged);
  }

  _onStarted(PreviewStarted event, Emitter<PreviewState> emit) async {
    final groups = groupBy(event.words, (word) => word.category);
    final String currentGroupKey = groups.keys.first;

    int pageCount = _caculatePageCount(groups, currentGroupKey);
    emit(PreviewLoaded(
      group2words: groups,
      currentGroupKey: currentGroupKey,
      pageCount: pageCount,
    ));
  }

  _onGroupChanged(PreviewGroupChanged event, Emitter<PreviewState> emit) async {
    final groupKey = event.groupKey;
    final theState = state as PreviewLoaded;

    int pageCount = _caculatePageCount(theState.group2words, groupKey);
    int currentPage = 0;

    emit(theState.copyWith(
      currentGroupKey: groupKey,
      pageCount: pageCount,
      currentPage: currentPage,
    ));
  }

  _onPageChanged(PreviewPageChanged event, Emitter<PreviewState> emit) async {
    final page = event.page;
    final theState = state as PreviewLoaded;
    emit(theState.copyWith(currentPage: page));
  }

  int _caculatePageCount(Map<String, List<Word>> groups, String groupKey) {
    final words = groups[groupKey]!;
    int wordCount = words.length;
    int pageCount = wordCount ~/ kWordCountPerPage;
    if (wordCount % kWordCountPerPage > 0) {
      pageCount++;
    }
    return pageCount;
  }
}
