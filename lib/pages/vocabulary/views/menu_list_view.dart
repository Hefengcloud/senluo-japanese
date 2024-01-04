import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/constants/colors.dart';
import 'package:senluo_japanese_cms/repos/vocabulary/models/vocabulary_menu.dart';

class MenuListView extends StatelessWidget {
  final List<VocabularyMenu> menus;
  final Function(VocabularyMenu menu, VocabularyMenu subMenu) onMenuClicked;

  const MenuListView({
    super.key,
    required this.menus,
    required this.onMenuClicked,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: menus
          .map((menu) => ExpansionTile(
                title: Text(
                  menu.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kBrandColor,
                  ),
                ),
                children: menu.subMenus
                    .map((subMenu) => ListTile(
                          leading: const Icon(Icons.arrow_right),
                          title: Text(subMenu.name),
                          onTap: () => onMenuClicked(menu, subMenu),
                        ))
                    .toList(),
              ))
          .toList(),
    );
  }
}
