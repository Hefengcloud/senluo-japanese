import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:senluo_japanese_cms/repos/zengo/models/zengo_item.dart';
import 'package:senluo_japanese_cms/repos/zengo/zengo_repository.dart';

part 'zengo_event.dart';
part 'zengo_state.dart';

class ZengoBloc extends Bloc<ZengoEvent, ZengoState> {
  final ZengoRepository repo;

  ZengoBloc(this.repo) : super(ZengoLoading()) {
    on<ZengoStarted>(_onStarted);
    on<ZengoItemChanged>(_onItemChanged);
    on<ZengoIndexChanged>(_onIndexChanged);
  }

  _onStarted(ZengoStarted event, Emitter<ZengoState> emit) async {
    final zengoCategories = await repo.loadZengos();
    final zengos = zengoCategories.expand((e) => e.items).toList();
    emit(ZengoLoaded(items: zengos));
  }

  _onItemChanged(ZengoItemChanged event, Emitter<ZengoState> emit) async {
    final theState = state as ZengoLoaded;
    emit(theState.copyWith(currentItem: event.item));
  }

  _onIndexChanged(ZengoIndexChanged event, Emitter<ZengoState> emit) async {
    final theState = state as ZengoLoaded;
    final theItem = theState.items[event.index];
    emit(theState.copyWith(currentItem: theItem));
  }
}
