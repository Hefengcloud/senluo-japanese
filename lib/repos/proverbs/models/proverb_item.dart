import 'package:equatable/equatable.dart';

class ProverbItem extends Equatable {
  final String name;
  final String reading;
  final List<String> meanings;
  final String? imgUrl;
  final List<ProverbExample> examples;

  const ProverbItem({
    required this.name,
    required this.reading,
    required this.meanings,
    this.imgUrl,
    this.examples = const [],
  });

  @override
  List<Object?> get props => [name, reading, meanings, imgUrl, examples];
}

class ProverbExample extends Equatable {
  final String jp;
  final String zh;

  const ProverbExample({this.jp = '', this.zh = ''});

  @override
  List<Object?> get props => [jp, zh];
}
