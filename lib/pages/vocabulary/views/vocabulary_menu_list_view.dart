import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/common/constants/colors.dart';
import 'package:senluo_japanese_cms/common/constants/themes.dart';
import 'package:senluo_japanese_cms/repos/vocabulary/models/vocabulary_menu.dart';

class VocabularyMenuListView extends StatefulWidget {
  final List<VocabularyMenu> menus;
  final Function(VocabularyMenu menu, VocabularyMenu subMenu) onMenuClicked;

  const VocabularyMenuListView({
    super.key,
    required this.menus,
    required this.onMenuClicked,
  });

  @override
  State<VocabularyMenuListView> createState() => _VocabularyMenuListViewState();
}

class _VocabularyMenuListViewState extends State<VocabularyMenuListView> {
  VocabularyMenu? _currentMenu;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.menus
          .map((menu) => ExpansionTile(
                title: Text(
                  menu.name,
                  style: kHomeNavTextStyle,
                ),
                children: menu.subMenus
                    .map((subMenu) => ListTile(
                          leading: const Icon(Icons.arrow_right),
                          trailing: subMenu == _currentMenu
                              ? const Icon(Icons.check)
                              : null,
                          title: Text(subMenu.name),
                          onTap: () {
                            setState(() {
                              _currentMenu = subMenu;
                            });
                            widget.onMenuClicked(menu, subMenu);
                          },
                        ))
                    .toList(),
              ))
          .toList(),
    );
  }
}
