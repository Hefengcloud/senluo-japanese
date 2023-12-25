part of 'gojuon_bloc.dart';

sealed class GojuonEvent extends Equatable {
  const GojuonEvent();

  @override
  List<Object> get props => [];
}

final class GojuonStarted extends GojuonEvent {}

final class GojuonKanaSelected extends GojuonEvent {
  final Kana kana;

  const GojuonKanaSelected({required this.kana});
}
