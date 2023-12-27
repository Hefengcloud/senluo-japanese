import 'package:equatable/equatable.dart';

class OnomatopoeiaCategory extends Equatable {
  final String key;
  final String name;
  final List<String> items;

  const OnomatopoeiaCategory(
      {required this.key, required this.name, required this.items});

  static const empty = OnomatopoeiaCategory(key: '', name: '', items: []);

  @override
  List<Object?> get props => [key, name, items];
}
