import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/pages/business/cashflow_page.dart';
import 'package:senluo_japanese_cms/pages/business/leadership_page.dart';
import 'package:senluo_japanese_cms/pages/business/marketing_page.dart';
import 'package:senluo_japanese_cms/pages/business/overhead_operation_page.dart';
import 'package:senluo_japanese_cms/pages/business/products_page.dart';
import 'package:senluo_japanese_cms/pages/business/sales_page.dart';
import 'package:senluo_japanese_cms/pages/expressions/expression_panel_page.dart';
import 'package:senluo_japanese_cms/pages/kana/kana_home_page.dart';
import 'package:senluo_japanese_cms/pages/keigo/keigo_home_page.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/onomatopoeia_home_page.dart';
import 'package:senluo_japanese_cms/pages/vocabulary/vocabulary_home_page.dart';

import '../grammars/grammar_home_page.dart';
import '../kanji/kanji_home_page.dart';
import '../proverbs/proverb_home_page.dart';
import '../zengo/zengo_home_page.dart';

class AppTitle extends Text {
  AppTitle({super.key})
      : super(
          '森罗日语',
          style: GoogleFonts.zhiMangXing(
            fontSize: 20,
            color: Colors.purple,
          ),
        );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SENLUO JAPANESE'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(child: Text("Leadership")),
              Tab(child: Text("Products")),
              Tab(child: Text("Marketing")),
              Tab(child: Text("Sales")),
              Tab(child: Text("Overhead Operation")),
              Tab(child: Text("Cashflow")),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LeadershipPage(),
            ProductsPage(),
            MarketingPage(),
            SalesPage(),
            OverheadOperationPage(),
            CashflowPage(),
          ],
        ),
        drawer: _buildDrawer(context),
      ),
    );
  }

  _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: AppTitle(),
          ),
          ListTile(
            title: const Text('仮名'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => KanaHomePage(),
              ),
            ),
          ),
          ListTile(
            title: const Text('文法'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => GrammarHomePage(),
              ),
            ),
          ),
          ListTile(
            title: const Text('語彙'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => VocabularyHomePage(),
              ),
            ),
          ),
          ListTile(
            title: const Text('漢字'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => KanjiHomePage(),
              ),
            ),
          ),
          ListTile(
            title: const Text('慣用語'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProverbHomePage(),
              ),
            ),
          ),
          ListTile(
            title: const Text('オノマトペ'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OnomatopoeiaHomePage(),
              ),
            ),
          ),
          ListTile(
            title: const Text('表現'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ExpressionHomePage(),
              ),
            ),
          ),
          ListTile(
            title: const Text('敬語'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => KeigoHomePage(),
              ),
            ),
          ),
          ListTile(
            title: const Text('禅語'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ZengoHomePage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
