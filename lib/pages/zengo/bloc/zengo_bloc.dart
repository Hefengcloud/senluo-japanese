import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:senluo_japanese_cms/repos/zengo/models/zengo_item.dart';

part 'zengo_event.dart';
part 'zengo_state.dart';

class ZengoBloc extends Bloc<ZengoEvent, ZengoState> {
  ZengoBloc() : super(ZengoInitial()) {
    on<ZengoItemChanged>((event, emit) { });
  }
}
