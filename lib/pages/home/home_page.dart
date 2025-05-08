import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senluo_japanese_cms/pages/business/cashflow_page.dart';
import 'package:senluo_japanese_cms/pages/business/leadership_page.dart';
import 'package:senluo_japanese_cms/pages/business/marketing_page.dart';
import 'package:senluo_japanese_cms/pages/business/overhead_operation_page.dart';
import 'package:senluo_japanese_cms/pages/business/products_page.dart';
import 'package:senluo_japanese_cms/pages/business/sales_page.dart';
import 'package:senluo_japanese_cms/pages/expressions/expression_panel_page.dart';
import 'package:senluo_japanese_cms/pages/keigo/keigo_home_page.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/onomatopoeia_home_page.dart';
import 'package:senluo_japanese_cms/pages/vocabulary/vocabulary_home_page.dart';

import '../../repos/business/business_repository.dart';
import '../grammars/grammar_home_page.dart';
import '../kanji/kanji_home_page.dart';
import '../proverbs/proverb_home_page.dart';
import '../tools/tools_home_page.dart';
import '../zengo/zengo_home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => BusinessRepository(),
      child: DefaultTabController(
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
      ),
    );
  }

  _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text(
              "森罗日语",
              style: GoogleFonts.zhiMangXing(
                fontSize: 48,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          ListTile(
            title: const Text('文法'),
            onTap: () => _goto(const GrammarHomePage()),
          ),
          ListTile(
            title: const Text('語彙'),
            onTap: () => _goto(const VocabularyHomePage()),
          ),
          ListTile(
            title: const Text('漢字'),
            onTap: () => _goto(const KanjiHomePage()),
          ),
          ListTile(
            title: const Text('慣用語'),
            onTap: () => _goto(const ProverbHomePage()),
          ),
          ListTile(
            title: const Text('オノマトペ'),
            onTap: () => _goto(const OnomatopoeiaHomePage()),
          ),
          ListTile(
            title: const Text('表現'),
            onTap: () => _goto(const ExpressionHomePage()),
          ),
          ListTile(
            title: const Text('敬語'),
            onTap: () => _goto(const KeigoHomePage()),
          ),
          ListTile(
            title: const Text('禅語'),
            onTap: () => _goto(const ZengoHomePage()),
          ),
          ListTile(
            title: const Text('ツール'),
            onTap: () => _goto(const ToolsHomePage()),
          ),
        ],
      ),
    );
  }

  _goto(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }
}
