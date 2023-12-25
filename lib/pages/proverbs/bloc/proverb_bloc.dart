import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:senluo_japanese_cms/repos/proverbs/proverb_repository.dart';

import '../../../repos/proverbs/models/proverb_item.dart';

part 'proverb_event.dart';
part 'proverb_state.dart';

class ProverbBloc extends Bloc<ProverbEvent, ProverbState> {
  final ProverbRepository proverbRepository;
  ProverbBloc({required this.proverbRepository}) : super(ProverbLoading()) {
    on<ProverbStarted>(_onStarted);
    on<ProverbSearched>(_onSearched);
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
}
