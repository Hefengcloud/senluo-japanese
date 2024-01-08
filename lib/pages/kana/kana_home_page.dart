import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/common/constants/number_constants.dart';

import 'bloc/kana_bloc.dart';
import 'views/kana_category_list_view.dart';
import 'views/kana_table_view.dart';

class KanaHomePage extends StatelessWidget {
  const KanaHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('仮名'),
      ),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return BlocBuilder<KanaBloc, KanaState>(
      builder: (context, state) {
        final bloc = BlocProvider.of<KanaBloc>(context);
        if (state is KanaLoading) {
          return _buildLoading(context);
        } else if (state is KanaLoaded) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: kMenuPanelWidth,
                child: KanaCategoryListView(
                  selectedType: state.currentKanaType,
                  onKanaTypeSelected: (type) {
                    bloc.add(KanaCategoryChanged(category: type));
                  },
                ),
              ),
              Expanded(
                child: KanaTableView(
                  kanaRows: state.currentKanaRows(),
                  kanaType: state.currentKanaType,
                  onKanaTap: (kana) {},
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
