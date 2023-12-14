import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/jlpt/grammar_panel_page.dart';

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
                label: Text('文法'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.view_module_outlined),
                selectedIcon: Icon(Icons.view_module),
                label: Text('ことわざ'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.donut_small_outlined),
                selectedIcon: Icon(Icons.donut_small),
                label: Text('語彙'),
              )
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          const Expanded(child: GrammarPanelPage()),
        ],
      ),
    );
  }
}
