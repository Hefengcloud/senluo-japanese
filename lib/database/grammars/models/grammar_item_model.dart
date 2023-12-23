class GrammarItemModel {
  final int id;
  final String name;
  final String level;
  final String meaning;

  const GrammarItemModel({
    required this.id,
    required this.name,
    required this.level,
    required this.meaning,
  });

  factory GrammarItemModel.empty() => const GrammarItemModel(
        id: 0,
        name: '',
        level: '',
        meaning: '',
      );

  factory GrammarItemModel.fromMap(Map<String, dynamic> map) {
    return GrammarItemModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      level: map['level'] ?? '',
      meaning: map['meaning'] ?? '',
    );
  }
}
