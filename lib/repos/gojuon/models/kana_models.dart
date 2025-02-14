import 'package:equatable/equatable.dart';

enum KanaCategory {
  seion,
  dakuon,
  handakuon,
  yoon,
  all,
}

enum KanaType {
  hiragana,
  katakana,
  all,
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
