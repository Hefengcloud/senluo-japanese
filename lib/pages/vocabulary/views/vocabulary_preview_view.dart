import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/common/constants/number_constants.dart';

import '../../../common/models/word.dart';
import '../../../helpers/image_helper.dart';
import '../../kanji/constants/styles.dart';
import '../../onomatopoeia/constants/colors.dart';
import '../bloc/preview_bloc.dart';

class VocabularyPreviewView extends StatelessWidget {
  VocabularyPreviewView({super.key});

  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreviewBloc, PreviewState>(
      builder: (context, state) {
        if (state is PreviewLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PreviewLoaded) {
          return Row(
            children: [
              Expanded(
                flex: kPreviewLeftFlex,
                child: RepaintBoundary(
                  key: _globalKey,
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: _buildImage(context, state),
                  ),
                ),
              ),
              Expanded(
                flex: kPreviewRightFlex,
                child: _buildPanel(context, state),
              )
            ],
          );
        }
        return const Center(child: Text('Error...'));
      },
    );
  }

  _buildImage(BuildContext context, PreviewLoaded state) => Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(color: kItemBgColor),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Gap(18),
            Text(
              '日语背单词',
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(
                'ZCOOL KuaiLe',
                fontSize: 36,
                color: kItemMainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            AutoSizeText(
              state.currentGroupKey,
              style: GoogleFonts.getFont(
                kKanjiFontName,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
            const Gap(18),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: state.displayedWords
                    .map<Widget>((word) => _buildWordCard(word))
                    .toList(),
              ),
            ),
          ],
        ),
      );

  _buildWordCard(Word word) => Card(
        color: Colors.white,
        shadowColor: Colors.transparent,
        child: Column(
          children: [
            const Gap(24),
            AutoSizeText(
              word.text,
              style: GoogleFonts.getFont(
                'Yusei Magic',
                fontSize: 20,
                color: kItemMainColor,
              ),
            ),
            Text(
              word.reading,
              style: GoogleFonts.getFont(
                'Yusei Magic',
                color: Colors.black45,
              ),
            ),
            const Spacer(),
            Text(
              word.meaning.en,
              textAlign: TextAlign.center,
            ),
            const Gap(24),
          ],
        ),
      );

  _buildPanel(BuildContext context, PreviewLoaded state) {
    final groupKeys = state.group2words.keys.toList();
    return Stack(
      children: [
        DefaultTabController(
          length: groupKeys.length,
          child: Builder(builder: (context) {
            final controller = DefaultTabController.of(context);
            controller.addListener(
              () {
                BlocProvider.of<PreviewBloc>(context).add(
                  PreviewGroupChanged(groupKey: groupKeys[controller.index]),
                );
              },
            );
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TabBar(
                  tabs: groupKeys.map((e) => Tab(text: e)).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: groupKeys
                        .map<Widget>((key) =>
                            _buildWordListView(state.group2words[key]!))
                        .toList(),
                  ),
                ),
                const Gap(80),
              ],
            );
          }),
        ),
        Positioned.fill(
          left: 16,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: _buildBottomActions(context, state),
          ),
        ),
      ],
    );
  }

  Column _buildBottomActions(BuildContext context, PreviewLoaded state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPageChoices(context, state),
        const Gap(16),
        ElevatedButton(
          child: const Text('Save Image'),
          onPressed: () => _onSaveImage("words.jpg"),
        ),
      ],
    );
  }

  _onSaveImage(String fileName) async {
    final bytes = await captureWidget(_globalKey);
    saveImageToFile(bytes!, '$fileName.jpg');
  }

  _buildWordListView(List<Word> words) => ListView(
        children: words.map((e) => ListTile(title: Text(e.text))).toList(),
      );

  _buildPageChoices(BuildContext context, PreviewLoaded state) {
    return Wrap(
      spacing: 5.0,
      children: List<Widget>.generate(
        state.pageCount,
        (int index) {
          return ChoiceChip(
            label: Text('${index + 1}'),
            side: BorderSide.none,
            selected: state.currentPage == index,
            onSelected: (bool selected) {
              BlocProvider.of<PreviewBloc>(context)
                  .add(PreviewPageChanged(page: selected ? index : 0));
            },
          );
        },
      ).toList(),
    );
  }
}
