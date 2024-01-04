import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/pages/vocabulary/views/menu_list_view.dart';
import 'package:senluo_japanese_cms/repos/vocabulary/models/vocabulary_menu.dart';
import 'package:senluo_japanese_cms/repos/vocabulary/vocabulary_repository.dart';

import '../../../common/models/word.dart';
import '../bloc/vocabulary_bloc.dart';

class VocabularyCategoryPage extends StatelessWidget {
  const VocabularyCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VocabularyBloc, VocabularyState>(
      builder: (context, state) {
        if (state is VocabularyLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is VocabularyLoaded) {
          final menus = state.type2Menus[VocabularyType.category];
          return Row(
            children: [
              Expanded(
                flex: 1,
                child: MenuListView(
                  menus: menus ?? [],
                  onMenuClicked: (menu, subMenu) =>
                      _onMenuClicked(context, menu, subMenu),
                ),
              ),
              Expanded(
                flex: 3,
                child: _buildRightPanel(state.wordList),
              ),
            ],
          );
        } else {
          return Text('Error');
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

  _buildRightPanel(List<Word> words) {
    return GridView.count(
      crossAxisCount: 8,
      children: words.map<Text>((word) => Text(word.text)).toList(),
    );
  }
}
