import 'package:equatable/equatable.dart';

class Example extends Equatable {
  final String jp;
  final String jp1;
  final String en;
  final String zh;

  const Example({
    required this.jp,
    required this.jp1,
    required this.en,
    required this.zh,
  });

  @override
  List<Object?> get props => [jp, jp1, en, zh];
}
