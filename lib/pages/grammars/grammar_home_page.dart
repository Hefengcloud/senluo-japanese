import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/pages/grammars/grammar_list_page.dart';
import 'package:senluo_japanese_cms/pages/grammars/grammar_tutorial_page.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

import '../../common/enums/enums.dart';
import 'bloc/grammar_bloc.dart';

class GrammarHomePage extends StatefulWidget {
  const GrammarHomePage({super.key});

  @override
  State<GrammarHomePage> createState() => _GrammarHomePageState();
}

class _GrammarHomePageState extends State<GrammarHomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      final keyword = _searchController.text.trim();
      BlocProvider.of<GrammarBloc>(context)
          .add(GrammarKeywordChanged(keyword: keyword));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GrammarBloc, GrammarState>(
      builder: (context, state) {
        return Scaffold(
          body: _buildBody(context, state),
        );
      },
      listener: (BuildContext context, GrammarState state) {
        if (state is GrammarLoaded && state.currentItem != GrammarItem.empty) {}
      },
    );
  }

  _buildBody(BuildContext context, GrammarState state) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const Gap(64),
          Text(
            "文法辞書",
            textAlign: TextAlign.center,
            style: GoogleFonts.yuseiMagic(
              fontSize: 64,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const Gap(16),
          _buildSearchInput(),
          const Gap(16),
          _buildTutorialEntry(context),
          const Gap(16),
          if (state is GrammarLoaded) _buildLevelEntries(context, state),
        ],
      ),
    );
  }

  _buildTutorialEntry(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => const GrammarTutorialPage()),
          );
        },
        child: Text.rich(
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
          TextSpan(children: [
            const TextSpan(text: "👉 "),
            TextSpan(
              text: "日本語文法入門",
              style: GoogleFonts.yuseiMagic(
                fontSize: 20,
                decoration: TextDecoration.underline,
              ),
            ),
            const TextSpan(text: " 👈"),
          ]),
        ),
      ),
    );
  }

  _buildLevelEntries(BuildContext context, GrammarLoaded state) {
    return GridView.count(
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      crossAxisCount: 3,
      childAspectRatio: 2,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: JLPTLevel.values
          .take(6)
          .map(
            (e) => InkWell(
              onTap: () => _onEntryChanged(context, e),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: e.color.withAlpha(30),
                ),
                child: Center(
                  child: Text(
                    e.name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.yuseiMagic(
                      color: e.color,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  _onEntryChanged(BuildContext context, JLPTLevel level) {
    context.read<GrammarBloc>().add(GrammarLevelChanged(level: level));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const GrammarListPage(),
      ),
    );
  }

  _buildSearchInput() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: '検索...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        // Clear button
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _searchController.clear();
          },
        ),
      ),
    );
  }
}
