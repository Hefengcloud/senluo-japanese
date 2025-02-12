import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
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
          const Text('Space: '),
          Expanded(
            child: Slider(
                min: 4,
                max: 24,
                value: _dividerGap,
                onChanged: (value) {
                  setState(() {
                    _dividerGap = value;
                  });
                }),
          ),
          IconButton(
            tooltip: 'Copy Text',
            icon: const Icon(Icons.copy_outlined),
            onPressed: () => _onCopyText(),
          ),
          IconButton(
            tooltip: 'Save image',
            icon: const Icon(Icons.save_outlined),
            onPressed: () => _onSaveImage(
                context, "${widget.item.level.name}-${widget.item.key}"),
          ),
        ],
      ),
    );
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
      backgroundColor: Colors.white.withValues(alpha: 0.4),
      child: ListView(
        children: [
          const ListTile(
            title: Text(
              '[例文]',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ...state.item.examples.map<CheckboxListTile>(
            (e) => CheckboxListTile(
              title: Text(
                e.jp,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onChanged: (bool? value) {
                context
                    .read<GrammarItemBloc>()
                    .add(GrammarExampleSelected(example: e));
              },
              value: state.isExampleDisplayed(e),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1),
          ),
          const ListTile(title: Text('[フォントサイズ]')),
          Slider(
            min: 12,
            max: 18,
            value: _exampleFontSize,
            onChanged: (double value) {
              setState(() {
                _exampleFontSize = value;
              });
            },
          ),
        ],
      ),
    );
  }

  _onSaveImage(BuildContext context, String fileName) async {
    final device = Device.get();
    final bytes = await captureWidget(_globalKey);
    if (device.isPhone) {
      final result = await saveImageToGallery(bytes!);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image ${result ? "" : "NOT "} Saved!')),
      );
    } else {
      saveImageToFile(bytes!, '$fileName.jpg');
    }
  }

  _onCopyText() async {
    await Clipboard.setData(ClipboardData(text: widget.item.text));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Text Copied')));
  }
}
