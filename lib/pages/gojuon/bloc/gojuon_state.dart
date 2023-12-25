part of 'gojuon_bloc.dart';

sealed class GojuonState extends Equatable {
  const GojuonState();

  @override
  List<Object> get props => [];
}

final class GojuonLoading extends GojuonState {}

final class GojuonLoaded extends GojuonState {
  final Gojuon gojuon;
  final Kana kana;

  const GojuonLoaded({
    required this.gojuon,
    this.kana = Kana.empty,
  });

  @override
  List<Object> get props => [gojuon, kana];
}
