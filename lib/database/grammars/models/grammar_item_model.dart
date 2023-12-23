class GrammarItemModel {
  final int id;
  final String name;
  final String level;
  final String meaning;
  final String conjugation;
  final String explanation;
  final String example;

  const GrammarItemModel({
    required this.id,
    required this.name,
    required this.level,
    required this.meaning,
    required this.conjugation,
    required this.explanation,
    required this.example,
  });

  factory GrammarItemModel.empty() => const GrammarItemModel(
        id: 0,
        name: '',
        level: '',
        meaning: '',
        conjugation: '',
        explanation: '',
        example: '',
      );

  factory GrammarItemModel.fromMap(Map<String, dynamic> map) {
    return GrammarItemModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      level: map['level'] ?? '',
      meaning: map['meaning'] ?? '',
      conjugation: map['conjugation'] ?? '',
      explanation: map['explanation'] ?? '',
      example: map['example'] ?? '',
    );
  }
}
