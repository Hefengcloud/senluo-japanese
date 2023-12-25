import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/pages/gojuon/gojuon_panel_page.dart';
import 'package:senluo_japanese_cms/pages/proverbs/proverb_panel_page.dart';
import 'package:senluo_japanese_cms/pages/vocabulary/vocabulary_panel_page.dart';

import '../grammars/grammar_panel_page.dart';
import '../kanji/kanji_panel_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final _pages = [
    const GojuonPanelPage(),
    const GrammarPanelPage(),
    const VocabularyPanelPage(),
    const KanjiPanelPage(),
    const ProverbPanelPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            leading: Text(
              '森罗\n日语',
              style: GoogleFonts.getFont(
                'Zhi Mang Xing',
                fontSize: 20,
                color: Colors.purple,
              ),
            ),
            groupAlignment: -1,
            labelType: NavigationRailLabelType.all,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore),
                label: Text('五十音'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.view_module_outlined),
                selectedIcon: Icon(Icons.view_module),
                label: Text('文法'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.thumb_up_outlined),
                selectedIcon: Icon(Icons.thumb_up),
                label: Text('語彙'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.fmd_good_outlined),
                selectedIcon: Icon(Icons.fmd_good),
                label: Text('漢字'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.donut_small_outlined),
                selectedIcon: Icon(Icons.donut_small),
                label: Text('慣用語'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _buildPanel(_selectedIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildPanel(int index) {
    if (index < _pages.length) {
      return _pages[index];
    } else {
      return Text('Invalid index: $index');
    }
  }
}
