import 'package:equatable/equatable.dart';

import 'kana_models.dart';

class Gojuon extends Equatable {
  final List<List<Kana>> seion;
  final List<List<Kana>> dakuon;
  final List<List<Kana>> handakuon;
  final List<List<Kana>> yoon;

  const Gojuon({
    required this.seion,
    required this.dakuon,
    required this.handakuon,
    required this.yoon,
  });

  @override
  List<Object?> get props => [
        seion,
        dakuon,
        handakuon,
        yoon,
      ];
}
