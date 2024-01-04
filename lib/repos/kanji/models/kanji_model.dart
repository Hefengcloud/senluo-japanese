import 'package:equatable/equatable.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';

class Kanji extends Equatable {
  final String char;
  final String key;
  final JLPTLevel level;

  const Kanji({
    required this.char,
    required this.key,
    required this.level,
  });

  @override
  List<Object?> get props => [char, key, level];
}

class KanjiDetail extends Kanji {
  final List<String> kunyomis;
  final List<String> onyomis;
  final String meaning;
  final String strokeCount;
  final String radical;
  final List<String> words;
  final List<String> idioms;
  final List<String> proverbs;

  const KanjiDetail({
    required super.char,
    required super.key,
    required super.level,
    required this.kunyomis,
    required this.onyomis,
    required this.meaning,
    required this.strokeCount,
    required this.radical,
    required this.words,
    required this.idioms,
    required this.proverbs,
  });

  static const empty = KanjiDetail(
    char: '',
    key: '',
    level: JLPTLevel.none,
    onyomis: [],
    kunyomis: [],
    meaning: '',
    radical: '',
    strokeCount: '',
    words: [],
    proverbs: [],
    idioms: [],
  );
}
