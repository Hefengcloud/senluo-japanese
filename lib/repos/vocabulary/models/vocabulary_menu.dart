class VocabularyMenu {
  final String name;
  final String key;
  final List<VocabularyMenu> subMenus;

  VocabularyMenu({
    required this.name,
    required this.key,
    this.subMenus = const [],
  });
}
