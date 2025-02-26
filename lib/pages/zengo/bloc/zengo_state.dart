part of 'zengo_bloc.dart';

sealed class ZengoState extends Equatable {
  const ZengoState();
  
  @override
  List<Object> get props => [];
}

final class ZengoInitial extends ZengoState {}
