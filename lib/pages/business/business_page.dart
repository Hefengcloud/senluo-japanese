import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/common/constants/number_constants.dart';
import 'package:senluo_japanese_cms/pages/business/cashflow_page.dart';
import 'package:senluo_japanese_cms/pages/business/leadership_page.dart';
import 'package:senluo_japanese_cms/pages/business/marketing_page.dart';
import 'package:senluo_japanese_cms/pages/business/overhead_operation_page.dart';
import 'package:senluo_japanese_cms/pages/business/products_page.dart';
import 'package:senluo_japanese_cms/pages/business/sales_page.dart';

import 'constants/business_constants.dart';

class BusinessPage extends StatefulWidget {
  const BusinessPage({super.key});

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  BusinessPart _thePart = BusinessPart.leadership;

  @override
  Widget build(BuildContext context) {
    return _buildBoy();
  }

  Widget _buildBoy() {
    return Row(
      children: [
        SizedBox(
          width: kMenuPanelWidth,
          child: ListView(
            children: BusinessPart.values
                .map<ListTile>(
                  (e) => ListTile(
                    title: Text(e.value),
                    onTap: () => setState(() {
                      _thePart = e;
                    }),
                  ),
                )
                .toList(),
          ),
        ),
        Expanded(child: _buildDestPage(_thePart)),
      ],
    );
  }

  Widget _buildDestPage(BusinessPart part) {
    switch (part) {
      case BusinessPart.leadership:
        return const LeadershipPage();
      case BusinessPart.marketing:
        return const MarketingPage();
      case BusinessPart.sales:
        return const SalesPage();
      case BusinessPart.products:
        return const ProductsPage();
      case BusinessPart.overheadAndOperations:
        return const OverheadOperationPage();
      case BusinessPart.cashFlow:
        return const CashflowPage();
    }
  }
}
