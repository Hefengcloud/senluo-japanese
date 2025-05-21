import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/pages/kanji/bloc/kanji_bloc.dart';
import 'package:senluo_kanji/senluo_kanji.dart';
import 'package:senluo_kanji/views/kanji_image_view.dart';

import '../../common/helpers/image_helper.dart';

class KanjiDetailPage extends StatefulWidget {
  final int index;

  const KanjiDetailPage({super.key, required this.index});

  @override
  State<KanjiDetailPage> createState() => _KanjiDetailPageState();
}

class _KanjiDetailPageState extends State<KanjiDetailPage> {
  final GlobalKey globalKey = GlobalKey();

  double _fontScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KanjiBloc, KanjiState>(
      builder: (context, state) {
        if (state is KanjiLoaded && state.currentIndex >= 0) {
          return _buildKanjiDetail(context, state);
        } else {
          return _buildLoading(context);
        }
      },
    );
  }

  _buildLoading(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('漢字'),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  _buildKanjiDetail(BuildContext context, KanjiLoaded state) {
    return Scaffold(
      appBar: AppBar(title: const Text('漢字')),
      body: _buildBody(context, state),
      endDrawer: _buildDrawer(context, state.currentDetail),
      bottomNavigationBar:
          BottomAppBar(child: _buildBottomActions(state.currentDetail)),
    );
  }

  _buildBody(BuildContext context, KanjiLoaded state) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        final bloc = context.read<KanjiBloc>();
        if (details.primaryVelocity! > 0) {
          bloc.add(const KanjiDetailRequested(previous: true));
        } else if (details.primaryVelocity! < 0) {
          bloc.add(const KanjiDetailRequested(previous: false));
        }
      },
      child: Column(
        children: [
          RepaintBoundary(
            key: globalKey,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: KanjiImageView(
                detail: state.currentDetail,
                fontScale: _fontScale,
              ),
            ),
          ),
          const Spacer(),
          _buildPageNavigators(context, state),
          const Spacer(),
        ],
      ),
    );
  }

  _buildPageNavigators(BuildContext context, KanjiLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 48,
          onPressed: () {
            context
                .read<KanjiBloc>()
                .add(const KanjiDetailRequested(previous: true));
          },
          icon: const Icon(Icons.arrow_left),
        ),
        SizedBox(
          width: 100,
          child: Text(
            "${state.currentIndex + 1} / ${state.kanjis.length}",
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          iconSize: 48,
          onPressed: () {
            context
                .read<KanjiBloc>()
                .add(const KanjiDetailRequested(previous: false));
          },
          icon: const Icon(Icons.arrow_right),
        ),
      ],
    );
  }

  _buildBottomActions(Kanji kanji) => Row(
        children: [
          const Text('Scale:'),
          Expanded(
            child: Slider(
              value: _fontScale,
              min: 1,
              max: 1.5,
              onChanged: (value) {
                setState(() {
                  _fontScale = value;
                });
              },
            ),
          ),
          Text(_fontScale.toStringAsFixed(2)),
          IconButton(
            onPressed: () => _saveKanjiAsImage(kanji.key),
            icon: const Icon(Icons.save_outlined),
          ),
        ],
      );

  _saveKanjiAsImage(String name) async {
    final bytes = await captureWidget(globalKey);
    await saveImage(bytes!, '$name.png');
  }

  _buildDrawer(BuildContext context, KanjiDetail detail) {
    return Drawer(
      child: ListView(
        children: [
          const ListTile(title: Text('語彙リスト')),
          ...detail.words.map((e) {
            final word = parseMeaning(e);
            return ListTile(
              leading: const Text('言葉'),
              title: Text("${word.text}（${word.reading}）"),
              subtitle:
                  word.meaning.en.isNotEmpty ? Text(word.meaning.en) : null,
              onTap: () {},
            );
          }),
          ...detail.proverbs.map((e) {
            return ListTile(
              leading: const Text('こと\nわざ'),
              title: Text(e),
              onTap: () {},
            );
          }),
          ...detail.idioms.map((e) => ListTile(
                leading: const Text('四字\n熟語'),
                title: Text(e),
                onTap: () {},
              )),
        ],
      ),
    );
  }
}
