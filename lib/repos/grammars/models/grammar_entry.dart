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

  @override
  List<Object?> get props => [name, key, level];
}
