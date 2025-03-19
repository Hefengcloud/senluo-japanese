import 'package:senluo_bunpo/senluo_bunpo.dart';

class Word {
  final String text;
  final String reading;
  final Meaning meaning;
  final String _category;

  Word({
    required this.text,
    required this.reading,
    required this.meaning,
    String category = '',
  }) : _category = category;

  String get category => _category.isNotEmpty ? _category : '未分類';
}
