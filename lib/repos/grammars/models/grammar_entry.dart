import 'package:equatable/equatable.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';

class GrammarEntry extends Equatable {
  final String name;
  final String key;
  final JLPTLevel level;

  const GrammarEntry({
    required this.name,
    required this.key,
    required this.level,
  });

  static const empty = GrammarEntry(
    name: '',
    key: '',
    level: JLPTLevel.none,
  );

  @override
  List<Object?> get props => [name, key, level];
}
