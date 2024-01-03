import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/pages/gojuon/views/kana_category_list_view.dart';
import 'package:senluo_japanese_cms/pages/gojuon/views/kana_display_view.dart';
import 'package:senluo_japanese_cms/pages/gojuon/views/kana_table_view.dart';

import 'bloc/gojuon_bloc.dart';

class GojuonPanelPage extends StatelessWidget {
  const GojuonPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('五十音'),
      ),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return BlocBuilder<GojuonBloc, GojuonState>(
      builder: (context, state) {
        final bloc = BlocProvider.of<GojuonBloc>(context);
        if (state is GojuonLoading) {
          return _buildLoading(context);
        } else if (state is GojuonLoaded) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 1,
                child: KanaCategoryListView(),
              ),
              Expanded(
                flex: 3,
                child: KanaTableView(
                  gojuon: state.gojuon,
                  onKanaTap: (kana) => bloc.add(
                    GojuonKanaSelected(kana: kana),
                  ),
                ),
              ),
            ],
          );
        }
        return Placeholder();
      },
    );
  }

  _buildLoading(BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      );
}
