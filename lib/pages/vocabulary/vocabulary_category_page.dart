import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/pages/vocabulary/vocabulary_word_list_page.dart';

import '../../repos/vocabulary/models/vocabulary_menu.dart';
import '../../repos/vocabulary/vocabulary_repository.dart';
import 'bloc/vocabulary_bloc.dart';
import 'views/vocabulary_menu_list_view.dart';

class VocabularyCategoryPage extends StatelessWidget {
  const VocabularyCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VocabularyBloc, VocabularyState>(
      builder: (context, state) {
        if (state is VocabularyLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is VocabularyLoaded) {
          final menus = state.type2Menus[VocabularyType.category];
          return VocabularyMenuListView(
            menus: menus ?? [],
            onMenuClicked: (menu, subMenu) =>
                _onMenuClicked(context, menu, subMenu),
          );
        } else {
          return const Text('Error');
        }
      },
      listener: (BuildContext context, VocabularyState state) {
        if (state is VocabularyLoaded) {
          if (state.wordList.isNotEmpty) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => VocabularyWordListPage(
                  wordList: state.wordList,
                ),
              ),
            );
          }
        }
      },
    );
  }

  _onMenuClicked(
    BuildContext context,
    VocabularyMenu menu,
    VocabularyMenu subMenu,
  ) {
    final key = "category/${menu.key}/${subMenu.key}";
    BlocProvider.of<VocabularyBloc>(context)
        .add(VocabularyWordListStarted(key: key));
  }
}
