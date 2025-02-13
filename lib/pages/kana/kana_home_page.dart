import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/pages/kana/views/kana_table_yoon_view.dart';
import 'package:senluo_japanese_cms/repos/gojuon/models/kana_models.dart';

import 'bloc/kana_bloc.dart';
import 'views/kana_table_view.dart';

class KanaHomePage extends StatefulWidget {
  const KanaHomePage({super.key});

  @override
  State<KanaHomePage> createState() => _KanaHomePageState();
}

class _KanaHomePageState extends State<KanaHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext ctx) {
    return BlocBuilder<KanaBloc, KanaState>(
      builder: (context, state) {
        if (state is KanaLoading) {
          return _buildLoading(context);
        } else if (state is KanaLoaded) {
          return _buildKanaTable(context, state);
        }
        return const Placeholder();
      },
    );
  }

  _buildKanaTable(BuildContext context, KanaLoaded state) {
    return Column(
      children: [
        AppBar(title: const Text('五十音図')),
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '清音'),
            Tab(text: '濁音'),
            Tab(text: '拗音'),
          ],
        ),
        // TabBarView takes remaining space
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              KanaTableView(
                kanaRows: state.seion,
                kanaCategory: KanaCategory.seion,
                onKanaTap: (kana) {},
              ),
              KanaTableView(
                kanaRows: [...state.dakuon, ...state.handakuon],
                kanaCategory: KanaCategory.dakuon,
                onKanaTap: (kana) {},
              ),
              KanaTableYoonView(
                kanaRows: state.yoon,
                onKanaTap: (kana) {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildLoading(BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      );
}
