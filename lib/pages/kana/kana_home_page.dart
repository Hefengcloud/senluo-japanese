import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/pages/kana/kana_preview_page.dart';
import 'package:senluo_japanese_cms/pages/kana/views/kana_switcher.dart';
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
  var _selectedType = KanaType.all;
  bool _isPronunciationMode = false;

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
    return Stack(
      children: [
        Column(
          children: [
            AppBar(
              title: const Text('五十音図'),
              centerTitle: false,
              actions: [
                _buildModeToggle(context),
              ],
            ),
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
                    kanaType: _selectedType,
                    kanaRows: state.seion,
                    kanaCategory: KanaCategory.seion,
                    onKanaTap: (kana) => _onKanaTap(
                      context,
                      kana,
                      KanaCategory.seion,
                    ),
                  ),
                  KanaTableView(
                    kanaType: _selectedType,
                    kanaRows: [...state.dakuon, ...state.handakuon],
                    kanaCategory: KanaCategory.dakuon,
                    onKanaTap: (kana) => _onKanaTap(
                      context,
                      kana,
                      KanaCategory.dakuon,
                    ),
                  ),
                  KanaTableYoonView(
                    kanaRows: state.yoon,
                    kanaType: _selectedType,
                    onKanaTap: (kana) => _onKanaTap(
                      context,
                      kana,
                      KanaCategory.yoon,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 16,
          left: 0,
          right: 0,
          child: Center(
            child: KanaSwitcher(
              selectedType: _selectedType,
              onChanged: (type) {
                setState(() {
                  _selectedType = type;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  _onKanaTap(BuildContext context, Kana kana, KanaCategory category) {
    context.read<KanaBloc>().add(
          KanaSelected(
            category: category,
            kana: kana,
          ),
        );
    if (_isPronunciationMode) {
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const KanaPreviewPage(),
        ),
      );
    }
  }

  _buildModeToggle(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('発音モード', textAlign: TextAlign.center),
        const Gap(8),
        Switch(
          value: _isPronunciationMode,
          onChanged: (value) {
            setState(() {
              _isPronunciationMode = value;
            });
          },
        ),
        const Gap(8),
      ],
    );
    // return IconButton(
    //   icon: _isPronunciationMode
    //       ? const FaIcon(FontAwesomeIcons.volumeLow)
    //       : const FaIcon(FontAwesomeIcons.volumeXmark),
    //   onPressed: () {
    //     setState(() {
    //       _isPronunciationMode = !_isPronunciationMode;
    //     });
    //   },
    // );
  }

  _buildLoading(BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      );
}
