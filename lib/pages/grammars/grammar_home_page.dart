import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:senluo_japanese_cms/common/constants/number_constants.dart';
import 'package:senluo_japanese_cms/pages/grammars/grammar_preview_page.dart';
import 'package:senluo_japanese_cms/pages/grammars/views/grammar_menu_list_view.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

import '../../common/enums/enums.dart';
import '../../repos/grammars/models/grammar_entry.dart';
import 'bloc/grammar_bloc.dart';

class GrammarHomePage extends StatefulWidget {
  const GrammarHomePage({super.key});

  @override
  State<GrammarHomePage> createState() => _GrammarHomePageState();
}

class _GrammarHomePageState extends State<GrammarHomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      final keyword = _searchController.text.trim();
      BlocProvider.of<GrammarBloc>(context)
          .add(GrammarKeywordChanged(keyword: keyword));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrammarBloc, GrammarState>(
      builder: (context, state) {
        return _buildBody(context, state);
      },
    );
  }

  _buildBody(BuildContext context, GrammarState state) {
    return switch (state) {
      GrammarLoading() => const CircularProgressIndicator(),
      GrammarError() => const Text('Something went wrong!'),
      GrammarLoaded() => Device.get().isPhone
          ? _buildMenu(context, state.entryMap)
          : Row(
              children: [
                SizedBox(
                  width: kMenuPanelWidth,
                  child: _buildMenu(context, state.entryMap),
                ),
                if (state.currentItem != GrammarItem.empty)
                  Expanded(
                    child: GrammarPreviewView(item: state.currentItem),
                  ),
              ],
            ),
    };
  }

  _buildMenu(
    BuildContext context,
    Map<JLPTLevel, List<GrammarEntry>> entryMap,
  ) =>
      GrammarMenuListView(
        onEntrySelected: (entry) => BlocProvider.of<GrammarBloc>(context)
            .add(GrammarEntryChanged(entry: entry)),
        grammarsByLevel: entryMap,
      );
}
