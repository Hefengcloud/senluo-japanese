import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ruby_text/ruby_text.dart';
import 'package:senluo_japanese_cms/common/helpers/image_helper.dart';
import 'package:senluo_japanese_cms/pages/zengo/bloc/zengo_bloc.dart';
import 'package:senluo_japanese_cms/pages/zengo/zengo_background_page.dart';
import 'package:senluo_japanese_cms/repos/zengo/models/zengo_item.dart';

class ZengoDetailPage extends StatefulWidget {
  final int initialIndex;

  const ZengoDetailPage({super.key, required this.initialIndex});

  @override
  State<ZengoDetailPage> createState() => _ZengoDetailPageState();
}

class _ZengoDetailPageState extends State<ZengoDetailPage> {
  String _bgImgUrl = '';
  Color _titleColor = Colors.black;
  Color _subtitleColor = Colors.black;

  double _fontSizeScale = 1;

  PageController? _controller;

  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    _controller ??= PageController(initialPage: widget.initialIndex);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ZengoBloc>(context);
    return BlocBuilder<ZengoBloc, ZengoState>(
        bloc: bloc,
        builder: (bloc, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Zen'),
            ),
            body: state is ZengoLoaded
                ? _buildBody(context, state)
                : const Center(child: CircularProgressIndicator()),
            bottomNavigationBar: _buildBottomAppBar(context),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endContained,
            floatingActionButton: FloatingActionButton.small(
              onPressed: () => _onSaveImage(context, () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Saved!')));
              }),
              child: const Icon(Icons.arrow_downward),
            ),
          );
        });
  }

  _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          IconButton.filled(
            onPressed: () => _onChangeBgImage(context),
            icon: const Icon(Icons.image),
          ),
          IconButton.filled(
            onPressed: () => _onChangeFont(context),
            icon: const Icon(Icons.abc),
          )
        ],
      ),
    );
  }

  _buildBody(BuildContext context, ZengoLoaded state) {
    return RepaintBoundary(
      key: _globalKey,
      child: PageView(
        controller: _controller,
        children: state.items
            .map<Widget>(
              (e) => Container(
                decoration: BoxDecoration(
                  image: _bgImgUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(_bgImgUrl),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: AssetImage("assets/images/zen-bg.jpg"),
                          fit: BoxFit.cover,
                        ),
                ),
                child: _buildZengoCard(context, e),
              ),
            )
            .toList(),
      ),
    );
  }

  _buildZengoCard(BuildContext context, Zengo zen) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Gap(112),
        RubyText(
          textAlign: TextAlign.center,
          zen.lines
              .mapIndexed<RubyTextData>(
                (idx, e) => RubyTextData(
                  e,
                  style: GoogleFonts.zenKurenaido(
                    fontSize: 48 * _fontSizeScale,
                    fontWeight: FontWeight.bold,
                    color: _titleColor,
                  ),
                  ruby: zen.readings[idx],
                  rubyStyle: TextStyle(fontSize: 24 * _fontSizeScale),
                ),
              )
              .toList(),
        ),
        const Gap(16),
        const SizedBox(
          width: 50,
          child: Divider(color: Colors.white30),
        ),
        const Gap(16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            zen.meaning,
            textAlign: TextAlign.center,
            style: GoogleFonts.zenKurenaido(
              fontSize: 20 * _fontSizeScale,
              color: _subtitleColor,
            ),
          ),
        ),
      ],
    );
  }

  _onSaveImage(BuildContext context, VoidCallback callback) async {
    final bytes = await captureWidget(_globalKey);
    if (bytes != null) {
      await saveImageToGallery(bytes);
    }
    callback();
  }

  _onChangeBgImage(BuildContext context) async {
    final url = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const ZengoBackgroundPage()),
    );

    if (url != null) {
      setState(() {
        _bgImgUrl = url;
      });
    }
  }

  _onChangeFont(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _buildFontModifier(context);
      },
    );
  }

  _buildFontModifier(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(16),
            Text(
              'フォント',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Gap(16),
            const Divider(height: 1),
            const Gap(16),
            _ColorPicker(
              title: "タイトル",
              onColorPicked: (color) => setState(() {
                _titleColor = color;
              }),
            ),
            const Gap(8),
            _ColorPicker(
              title: "サブタイトル",
              onColorPicked: (color) => setState(() {
                _subtitleColor = color;
              }),
            ),
            _SizePicker(
              title: "フォントサイズ",
              onValueChanged: (value) {
                setState(() {
                  _fontSizeScale = value;
                });
              },
              initialValue: _fontSizeScale,
            ),
            const Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
            ),
            const Gap(64),
          ],
        ),
      );
}

class _SizePicker extends StatefulWidget {
  final String title;
  final double initialValue;
  final ValueChanged onValueChanged;

  const _SizePicker({
    required this.title,
    required this.initialValue,
    required this.onValueChanged,
  });

  @override
  State<_SizePicker> createState() => _SizePickerState();
}

class _SizePickerState extends State<_SizePicker> {
  late double _value;

  @override
  void initState() {
    _value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.labelLarge),
        Expanded(
          child: Slider(
            min: 1,
            max: 2,
            onChanged: (value) {
              setState(() {
                _value = value;
              });
              widget.onValueChanged(value);
            },
            value: _value,
          ),
        ),
        Text(_value.toStringAsFixed(2)),
      ],
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final ValueChanged onColorPicked;
  final String title;

  const _ColorPicker({
    required this.title,
    required this.onColorPicked,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.labelLarge),
        const Spacer(),
        Wrap(
          spacing: 5.0,
          children: [
            Colors.white,
            Colors.black,
            Colors.orange,
            Colors.green,
          ].mapIndexed((idx, e) {
            return InkWell(
              onTap: () => onColorPicked(e),
              child: SizedBox(
                width: 48.0,
                height: 48.0,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: e),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
