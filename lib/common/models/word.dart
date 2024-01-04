import 'package:senluo_japanese_cms/common/models/meaning.dart';

class Word {
  final String text;
  final String reading;
  final Meaning meaning;
  final String category;

  Word({
    required this.text,
    required this.reading,
    required this.meaning,
    this.category = '',
  });
}
