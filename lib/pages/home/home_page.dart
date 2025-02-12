import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/common/constants/themes.dart';
import 'package:senluo_japanese_cms/pages/home/helpers/navigation_helper.dart';
import 'package:senluo_japanese_cms/pages/home/helpers/navigation_item.dart';
import 'package:senluo_japanese_cms/pages/home/views/title_text_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final allEntries = buildNavigationItems();

  @override
  Widget build(BuildContext context) {
    final moreEntries = allEntries.sublist(4);

    final navItems = List<NavigationItem>.from(allEntries.getRange(0, 4))
      ..add(
        NavigationItem(
          icon: const Icon(Icons.more_horiz_outlined),
          selectedIcon: const Icon(Icons.more_horiz),
          label: "更多",
          page: _NavPage(moreEntries),
        ),
      );
    return Scaffold(
      appBar: AppBar(
        title: AppTitle(),
      ),
      body: navItems[_selectedIndex].page,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
        destinations: navItems
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

class _NavPage extends StatelessWidget {
  final List<NavigationItem> items;

  const _NavPage(this.items);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: items
            .map<ListTile>(
              (e) => ListTile(
                leading: e.icon,
                title: Text(e.label, style: kHomeNavTextStyle),
                trailing: const Icon(Icons.arrow_right),
                onTap: () => _onNavigate(context, e),
              ),
            )
            .toList(),
      ),
    );
  }

  _onNavigate(BuildContext context, NavigationItem item) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => item.page));
  }
}
