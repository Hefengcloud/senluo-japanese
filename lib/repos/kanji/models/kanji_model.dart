import 'package:equatable/equatable.dart';

class Kanji extends Equatable {
  final String char;
  final String key;

  const Kanji({required this.char, required this.key});

  @override
  List<Object?> get props => [char, key];
}

class KanjiDetail extends Kanji {
  final String kunyomi;
  final String onyomi;
  final String meaning;
  const KanjiDetail({
    required super.char,
    required super.key,
    required this.kunyomi,
    required this.onyomi,
    required this.meaning,
  });
}
