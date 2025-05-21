part of 'vocabulary_bloc.dart';

sealed class VocabularyState extends Equatable {
  const VocabularyState();

  @override
  List<Object> get props => [];
}

final class VocabularyLoading extends VocabularyState {}

final class VocabularyLoaded extends VocabularyState {
  final Map<VocabularyType, List<VocabularyMenu>> type2Menus;

  final List<VocabularyWord> wordList;
  final String currentPath;

  const VocabularyLoaded({
    required this.type2Menus,
    required this.wordList,
    required this.currentPath,
  });

  VocabularyMenu getCurrentMenu() {
    final parts = currentPath.split('/');
    final category = VocabularyType.values.firstWhere(
      (e) => e.name == parts[0],
    );
    final menu = type2Menus[category]!.firstWhere(
      (e) => e.key == parts[1],
    );
    if (parts.length > 2) {
      final subMenu = menu.subMenus.firstWhere(
        (e) => e.key == parts[2],
      );
      return subMenu;
    }
    return menu;
  }

  @override
  List<Object> get props => [type2Menus, wordList, currentPath];
}
