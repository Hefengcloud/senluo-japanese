import 'package:audioplayers/audioplayers.dart';
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
  late TabController _categoryTabController;
  bool _isPronunciationMode = false;
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _categoryTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _categoryTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    _categoryTabController.addListener(() {
      context.read<KanaBloc>().add(
            KanaCategoryChanged(
              category: KanaCategory.values[_categoryTabController.index],
            ),
          );
    });

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
              controller: _categoryTabController,
              tabs: const [
                Tab(text: '清音'),
                Tab(text: '濁音'),
                Tab(text: '拗音'),
              ],
            ),
            // TabBarView takes remaining space
            Expanded(
              child: TabBarView(
                controller: _categoryTabController,
                children: [
                  KanaTableView(
                    kanaType: state.type,
                    kanaRows: state.seion,
                    kanaCategory: KanaCategory.seion,
                    onKanaTap: (kana) => _onKanaTap(context, kana),
                  ),
                  KanaTableView(
                    kanaType: state.type,
                    kanaRows: state.dakuon,
                    kanaCategory: KanaCategory.dakuon,
                    onKanaTap: (kana) => _onKanaTap(context, kana),
                  ),
                  KanaTableYoonView(
                    kanaRows: state.yoon,
                    kanaType: state.type,
                    onKanaTap: (kana) => _onKanaTap(context, kana),
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
              selectedType: state.type,
              onChanged: (type) {
                context.read<KanaBloc>().add(KanaTypeChanged(type: type));
              },
            ),
          ),
        ),
      ],
    );
  }

  _onKanaTap(BuildContext context, Kana kana) async {
    final state = context.read<KanaBloc>().state as KanaLoaded;

    if (_isPronunciationMode) {
      final audioPath = 'kana/audios/${kana.key}.m4a';
      try {
        await _player.play(AssetSource(audioPath)); // For assets
      } catch (e) {
        print('Error playing audio: $e');
      }
    } else {
      final index = state.kanaTable[state.category]!
          .firstWhere((row) => row.contains(kana))
          .indexOf(kana);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RepositoryProvider(
            create: (context) => context.read<KanaBloc>().kanaRepo,
            child: KanaPreviewPage(
              initialIndex: index,
              kana: kana,
              type: state.type == KanaType.all ? KanaType.hiragana : state.type,
              category: state.category,
            ),
          ),
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
  }

  _buildLoading(BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      );
}
