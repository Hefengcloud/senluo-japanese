import 'package:equatable/equatable.dart';

class ZengoCategory extends Equatable {
  final String name;
  final List<Zengo> items;

  const ZengoCategory({
    required this.name,
    required this.items,
  });

  @override
  List<Object?> get props => [name, items];
}

class Zengo extends Equatable {
  final List<String> lines;
  final List<String> readings;
  final String meaning;

  const Zengo({
    required this.lines,
    required this.readings,
    required this.meaning,
  });

  static const empty = Zengo(lines: [], readings: [], meaning: '');

  @override
  List<Object?> get props => [lines, readings, meaning];
}
