import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/home/helpers/navigation_helper.dart';
import 'package:senluo_japanese_cms/pages/home/helpers/navigation_item.dart';
import 'package:senluo_japanese_cms/pages/home/nav_page.dart';
import 'package:senluo_japanese_cms/pages/home/views/title_text_view.dart';

class HomeMobilePage extends StatefulWidget {
  const HomeMobilePage({super.key});

  @override
  State<HomeMobilePage> createState() => _HomeMobilePageState();
}

class _HomeMobilePageState extends State<HomeMobilePage> {
  int _selectedIndex = 0;

  final _navItems =
      List<NavigationItem>.from(buildNavigationItems().getRange(0, 4))
        ..add(
          const NavigationItem(
            icon: Icon(Icons.more_horiz_outlined),
            selectedIcon: Icon(Icons.more_horiz),
            label: "更多",
            page: NavPage(),
          ),
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppTitle(),
      ),
      body: _navItems[_selectedIndex].page,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
        destinations: _navItems
            .map<NavigationDestination>(
              (e) => NavigationDestination(
                icon: e.icon,
                selectedIcon: e.selectedIcon,
                label: e.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
