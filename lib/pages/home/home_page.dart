import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/craftify/craftify_home_page.dart';
import 'package:senluo_japanese_cms/pages/home/helpers/navigation_helper.dart';
import 'package:senluo_japanese_cms/pages/home/views/title_text_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final _navItems = buildNavigationItems();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            leading: AppTitle(),
            groupAlignment: -1,
            labelType: NavigationRailLabelType.all,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: _navItems
                .map<NavigationRailDestination>(
                  (e) => NavigationRailDestination(
                      icon: e.icon,
                      selectedIcon: e.selectedIcon,
                      label: Text(e.label)),
                )
                .toList(),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: IconButton(
                    icon: const Icon(Icons.text_format),
                    onPressed: () => _gotoCraftifyPage(context),
                  ),
                ),
              ),
            ),
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
    if (index < _navItems.length) {
      return _navItems[index].page;
    } else {
      return Center(child: Text('Invalid index: $index'));
    }
  }

  _gotoCraftifyPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CraftifyHomePage(),
      ),
    );
  }
}
