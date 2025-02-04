import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:senluo_japanese_cms/pages/business/cashflow_page.dart';
import 'package:senluo_japanese_cms/pages/business/leadership_page.dart';
import 'package:senluo_japanese_cms/pages/business/marketing_page.dart';
import 'package:senluo_japanese_cms/pages/business/overhead_operation_page.dart';
import 'package:senluo_japanese_cms/pages/business/products_page.dart';
import 'package:senluo_japanese_cms/pages/business/sales_page.dart';

import 'constants/business_constants.dart';

typedef BizPartTapCallback = void Function(BusinessPart part);

class BusinessPage extends StatefulWidget {
  const BusinessPage({super.key});

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  BusinessPart _thePart = BusinessPart.leadership;

  @override
  Widget build(BuildContext context) {
    return Device.get().isPhone ? _buildMobileBody() : _buildBody();
  }

  Widget _buildBody() {
    return Row(
      children: [
        SizedBox(
          // width: kMenuPanelWidth,
          width: 40,
          child: _buildMenuList(
            (part) => setState(() {
              _thePart = part;
            }),
          ),
        ),
        Expanded(child: _buildDestPage(_thePart)),
      ],
    );
  }

  Widget _buildMenuList(BizPartTapCallback callback) {
    return ListView.separated(
      itemCount: BusinessPart.values.length,
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(height: 1),
      itemBuilder: (context, index) {
        final part = BusinessPart.values[index];
        return ListTile(
          title: Text(part.value),
          onTap: () => callback(part),
          trailing: const Icon(Icons.arrow_forward),
        );
      },
    );
  }

  _buildMobileBody() {
    return _buildMenuList(
      (part) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => _buildDestPage(part),
          ),
        );
      },
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
