import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:senluo_japanese_cms/repos/gojuon/gojuon_repository.dart';
import 'package:senluo_japanese_cms/repos/gojuon/models/gojuon_models.dart';

import '../../../repos/gojuon/models/models.dart';

part 'gojuon_event.dart';
part 'gojuon_state.dart';

class GojuonBloc extends Bloc<GojuonEvent, GojuonState> {
  final GojuonRepository gojuonRepository;
  GojuonBloc({required this.gojuonRepository}) : super(GojuonLoading()) {
    on<GojuonStarted>(_onStarted);
    on<GojuonKanaSelected>(_onItemSelected);
  }

  _onStarted(
    GojuonStarted event,
    Emitter<GojuonState> emit,
  ) async {
    emit(GojuonLoading());
    final gojuon = await gojuonRepository.loadGojuon();
    emit(GojuonLoaded(gojuon: gojuon));
  }

  _onItemSelected(
    GojuonKanaSelected event,
    Emitter<GojuonState> emit,
  ) async {
    final theState = state as GojuonLoaded;
    emit(
      GojuonLoaded(
        gojuon: theState.gojuon,
        kana: event.kana,
      ),
    );
  }
}
