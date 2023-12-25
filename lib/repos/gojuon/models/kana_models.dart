import 'package:equatable/equatable.dart';

enum KanaType {
  seion,
  dakuon,
  handakuon,
  yoon,
}

class Kana extends Equatable {
  final String hiragana;
  final String katakana;
  final String romaji;

  const Kana({
    required this.hiragana,
    required this.katakana,
    required this.romaji,
  });

  static const empty = Kana(hiragana: '', katakana: '', romaji: '');

  @override
  List<Object?> get props => [hiragana, katakana, romaji];
}
