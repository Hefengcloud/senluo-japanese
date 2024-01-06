import 'package:equatable/equatable.dart';

class GrammarEntry extends Equatable {
  final String name;
  final String key;
  final String level;

  const GrammarEntry({
    required this.name,
    required this.key,
    required this.level,
  });

  @override
  List<Object?> get props => [name, key, level];
}
