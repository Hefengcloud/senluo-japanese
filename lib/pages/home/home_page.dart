import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/business/business_page.dart';
import 'package:senluo_japanese_cms/pages/business/cashflow_page.dart';
import 'package:senluo_japanese_cms/pages/business/leadership_page.dart';
import 'package:senluo_japanese_cms/pages/business/marketing_page.dart';
import 'package:senluo_japanese_cms/pages/business/overhead_operation_page.dart';
import 'package:senluo_japanese_cms/pages/business/products_page.dart';
import 'package:senluo_japanese_cms/pages/business/sales_page.dart';
import 'package:senluo_japanese_cms/pages/kana/kana_home_page.dart';

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
          title: Text('SENLUO JAPANESE'),
          bottom: TabBar(
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
        body: TabBarView(
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
            child: Text('森罗日语'),
          ),
          ListTile(
            title: Text('仮名'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => KanaHomePage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
