import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:senluo_japanese_cms/pages/grammars/bloc/grammar_item_bloc.dart';
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

  var _fontScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GrammarItemBloc(context.read<GrammarRepository>())
        ..add(GrammarItemStarted(item: widget.item)),
      child: BlocBuilder<GrammarItemBloc, GrammarItemState>(
          builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('画像'),
          ),
          body: state is GrammarItemLoaded
              ? _buildImage(context, state)
              : _buildLoading(),
          bottomNavigationBar: _buildBottomBar(context),
          endDrawer:
              state is GrammarItemLoaded ? _buildDrawer(context, state) : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: state is GrammarItemLoaded
              ? FloatingActionButton(
                  child: const Icon(Icons.save_outlined),
                  onPressed: () {
                    _onSaveImage(context, state.displayedItem.key);
                  },
                )
              : null,
        );
      }),
    );
  }

  _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text('Font Scale: ${_fontScale.toStringAsFixed(2)}'),
          ),
          Expanded(
            child: Slider(
              min: 0.9,
              max: 1.1,
              value: _fontScale,
              onChanged: (double value) {
                setState(() {
                  _fontScale = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildImage(BuildContext context, GrammarItemLoaded state) {
    return Align(
      alignment: Alignment.topCenter,
      child: RepaintBoundary(
        key: _globalKey,
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: GrammarImageView(
            item: state.displayedItem,
            fontScale: _fontScale,
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
}
