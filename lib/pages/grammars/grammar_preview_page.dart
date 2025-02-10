import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:senluo_japanese_cms/pages/grammars/bloc/grammar_item_bloc.dart';
import 'package:senluo_japanese_cms/pages/grammars/constants/colors.dart';
import 'package:senluo_japanese_cms/pages/grammars/helpers/grammar_helper.dart';
import 'package:senluo_japanese_cms/pages/grammars/views/grammar_image_view.dart';
import 'package:senluo_japanese_cms/repos/grammars/grammar_repository.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

import '../../common/helpers/image_helper.dart';

class GrammarPreviewPage extends StatefulWidget {
  final GrammarItem item;

  const GrammarPreviewPage({super.key, required this.item});

  @override
  State<GrammarPreviewPage> createState() => _GrammarPreviewPageState();
}

class _GrammarPreviewPageState extends State<GrammarPreviewPage> {
  final GlobalKey _globalKey = GlobalKey();

  var _dividerGap = 8.0;
  var _exampleFontSize = 14.0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GrammarItemBloc(context.read<GrammarRepository>())
        ..add(GrammarItemStarted(item: widget.item)),
      child: BlocBuilder<GrammarItemBloc, GrammarItemState>(
          builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Preview'),
            actions: [
              IconButton(
                tooltip: 'Save image',
                icon: const Icon(Icons.save_outlined),
                onPressed: () => _onSaveImage(
                    "${widget.item.level.name}-${widget.item.key}"),
              ),
              IconButton(
                tooltip: 'Copy Text',
                icon: const Icon(Icons.copy_outlined),
                onPressed: () => _onCopyText(),
              ),
            ],
          ),
          body: state is GrammarItemLoaded
              ? _buildImage(context, state)
              : _buildLoading(),
          bottomNavigationBar: _buildBottomBar(context),
          endDrawer:
              state is GrammarItemLoaded ? _buildDrawer(context, state) : null,
        );
      }),
    );
  }

  _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          Text('Margin:'),
          Slider(
            min: 0,
            max: 24,
            divisions: 12,
            value: _dividerGap,
            onChanged: (double value) {
              setState(() {
                _dividerGap = value;
              });
            },
          ),
          const Gap(8),
          Text('FontSize:'),
          Slider(
            min: 12,
            max: 18,
            divisions: 6,
            value: _exampleFontSize,
            onChanged: (double value) {
              setState(
                () {
                  _exampleFontSize = value;
                },
              );
            },
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.list_outlined),
            onPressed: () => _showExampleList(context),
          ),
        ],
      ),
    );
  }

  _showExampleList(BuildContext context) async {
    final bloc = context.read<GrammarItemBloc>();
  }

  _buildImage(BuildContext context, GrammarItemLoaded state) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: 480.0,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: kLevel2color[widget.item.level],
        ),
        child: RepaintBoundary(
          key: _globalKey,
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: GrammarImageView(
              item: state.displayedItem,
              dividerGap: _dividerGap,
              exampleFontSize: _exampleFontSize,
            ),
          ),
        ),
      ),
    );
  }

  _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  _buildDrawer(BuildContext context, GrammarItemLoaded state) {
    return Drawer(
      child: ListView(
        children: [
          const ListTile(title: Text('[例文]')),
          ...state.item.examples.map<CheckboxListTile>(
            (e) => CheckboxListTile(
              title: Text(e.jp),
              onChanged: (bool? value) {
                context
                    .read<GrammarItemBloc>()
                    .add(GrammarExampleSelected(example: e));
              },
              value: state.isExampleDisplayed(e),
            ),
          ),
        ],
      ),
    );
  }

  _onSaveImage(String fileName) async {
    final bytes = await captureWidget(_globalKey);
    saveImageToFile(bytes!, '$fileName.jpg');
  }

  _onCopyText() async {
    await Clipboard.setData(ClipboardData(text: widget.item.text));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Copied')));
  }
}
