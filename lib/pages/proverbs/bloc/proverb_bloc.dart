import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:senluo_japanese_cms/constants/kanas.dart';
import 'package:senluo_japanese_cms/repos/proverbs/proverb_repository.dart';

import '../../../repos/proverbs/models/proverb_item.dart';

part 'proverb_event.dart';
part 'proverb_state.dart';

class ProverbBloc extends Bloc<ProverbEvent, ProverbState> {
  final ProverbRepository proverbRepository;
  ProverbBloc({required this.proverbRepository}) : super(ProverbLoading()) {
    on<ProverbStarted>(_onStarted);
    on<ProverbSearched>(_onSearched);
    on<ProverbFiltered>(_onFiltered);
    on<ProverbSelected>(_onSelected);
    on<ProverbChanged>(_onChanged);
  }

  _onStarted(
    ProverbStarted event,
    Emitter<ProverbState> emit,
  ) async {
    emit(ProverbLoading());
    final List<ProverbItem> items = await proverbRepository.loadProverbs();
    emit(ProverbLoaded(items: items));
  }

  _onSearched(
    ProverbSearched event,
    Emitter<ProverbState> emit,
  ) async {
    emit(ProverbLoading());
    final items = await proverbRepository.searchProverbs(event.keyword);
    emit(ProverbLoaded(items: items));
  }

  _onFiltered(
    ProverbFiltered event,
    Emitter<ProverbState> emit,
  ) async {
    emit(ProverbLoading());
    final items =
        await proverbRepository.loadProverbsByKanaLine(event.kanaLine);
    emit(ProverbLoaded(
      items: items,
      currentKanaLine: event.kanaLine,
    ));
  }

  _onSelected(
    ProverbSelected event,
    Emitter<ProverbState> emit,
  ) async {
    final theState = state as ProverbLoaded;
    emit(theState.copyWith(currentItem: event.item));
  }

  _onChanged(
    ProverbChanged event,
    Emitter<ProverbState> emit,
  ) async {
    final theState = state as ProverbLoaded;
    final currentItem = theState.currentItem;
    final currentIndex = theState.items.indexOf(currentItem);
    int theIndex = currentIndex;
    if (event.next) {
      if (currentIndex + 1 < theState.items.length) {
        theIndex = currentIndex + 1;
      }
    } else {
      if (currentIndex - 1 >= 0) {
        theIndex = currentIndex - 1;
      }
    }
    add(ProverbSelected(item: theState.items[theIndex]));
  }
}
