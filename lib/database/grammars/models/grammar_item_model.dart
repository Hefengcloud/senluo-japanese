class GrammarItemModel {
  final String name;
  final String meaning;

  const GrammarItemModel({
    required this.name,
    required this.meaning,
  });

  factory GrammarItemModel.fromMap(Map<String, dynamic> map) {
    return GrammarItemModel(
      name: map['name'] ?? '',
      meaning: map['meaning'] ?? '',
    );
  }
}
