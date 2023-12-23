import 'package:equatable/equatable.dart';

class ProverbItem extends Equatable {
  final String name;
  final String reading;
  final List<String> meanings;

  const ProverbItem({
    required this.name,
    required this.reading,
    required this.meanings,
  });

  @override
  List<Object?> get props => [name, reading, meanings];
}
