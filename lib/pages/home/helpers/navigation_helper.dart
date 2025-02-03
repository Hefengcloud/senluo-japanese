import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/business/business_page.dart';
import 'package:senluo_japanese_cms/pages/home/helpers/navigation_item.dart';

import '../../expressions/expression_panel_page.dart';
import '../../grammars/grammar_home_page.dart';
import '../../kana/kana_home_page.dart';
import '../../kanji/kanji_home_page.dart';
import '../../keigo/keigo_home_page.dart';
import '../../onomatopoeia/onomatopoeia_page.dart';
import '../../proverbs/proverb_home_page.dart';
import '../../vocabulary/vocabulary_home_page.dart';

List<NavigationItem> buildNavigationItems() => [
      NavigationItem(
        icon: const Icon(Icons.business),
        selectedIcon: const Icon(Icons.business_outlined),
        label: 'ビジネス',
        page: const BusinessPage(),
      ),
      NavigationItem(
        icon: const Icon(Icons.explore_outlined),
        selectedIcon: const Icon(Icons.explore),
        label: '假名',
        page: const KanaHomePage(),
      ),
      NavigationItem(
        icon: const Icon(Icons.view_module_outlined),
        selectedIcon: const Icon(Icons.view_module),
        label: '文法',
        page: const GrammarHomePage(),
      ),
      NavigationItem(
        icon: const Icon(Icons.thumb_up_outlined),
        selectedIcon: const Icon(Icons.thumb_up),
        label: '単語',
        page: const VocabularyHomePage(),
      ),
      NavigationItem(
        icon: const Icon(Icons.fmd_good_outlined),
        selectedIcon: const Icon(Icons.fmd_good),
        label: '漢字',
        page: const KanjiHomePage(),
      ),
      NavigationItem(
        icon: const Icon(Icons.donut_small_outlined),
        selectedIcon: const Icon(Icons.donut_small),
        label: '慣用語',
        page: const ProverbHomePage(),
      ),
      NavigationItem(
        icon: const Icon(Icons.adb_outlined),
        selectedIcon: const Icon(Icons.adb),
        label: 'オノマトペ',
        page: const OnomatopoeiaHomePage(),
      ),
      NavigationItem(
        icon: const Icon(Icons.speaker_outlined),
        selectedIcon: const Icon(Icons.speaker),
        label: '表現',
        page: const ExpressionHomePage(),
      ),
      NavigationItem(
        icon: const Icon(Icons.account_box_outlined),
        selectedIcon: const Icon(Icons.account_box),
        label: '敬語',
        page: const KeigoHomePage(),
      ),
    ];
