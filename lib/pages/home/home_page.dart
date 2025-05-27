import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repos/business/business_repository.dart';
import '../business/cashflow_page.dart';
import '../business/leadership_page.dart';
import '../business/marketing_page.dart';
import '../business/overhead_operation_page.dart';
import '../business/products_page.dart';
import '../business/sales_page.dart';

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
        ),
      ),
    );
  }
}
