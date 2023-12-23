import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/gojuon/gojuon_panel_page.dart';
import 'package:senluo_japanese_cms/pages/jlpt/grammar_panel_page.dart';
import 'package:senluo_japanese_cms/pages/proverbs/proverb_panel_page.dart';
import 'package:senluo_japanese_cms/pages/vocabulary/vocabulary_panel_page.dart';

import '../kanji/kanji_panel_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            groupAlignment: 0,
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
    if (index == 0) {
      return const GojuonPanelPage();
    } else if (index == 1) {
      return const GrammarPanelPage();
    } else if (index == 2) {
      return const VocabularyPanelPage();
    } else if (index == 3) {
      return const KanjiPanelPage();
    } else if (index == 4) {
      return const ProverbPanelPage();
    }

    return Text('Invalid index: $index');
  }
}
