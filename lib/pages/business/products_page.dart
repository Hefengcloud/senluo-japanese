import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/business/constants/product_constants.dart';
import 'package:senluo_kana/pages/kana_home_page.dart';

import '../grammars/grammar_home_page.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
    const products = kMyProducts;

    return ListView.separated(
      itemBuilder: (ctx, idx) => ListTile(
        onTap: () {
          switch (idx) {
            case 0:
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const KanaHomePage()),
              );
            case 1:
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const GrammarHomePage()),
              );
          }
        },
        leading: Icon(
          products[idx].type.icon,
          color: Colors.green,
        ),
        title: Text(products[idx].name),
        subtitle: Text(products[idx].desc),
        trailing: const Icon(Icons.arrow_forward),
      ),
      separatorBuilder: (ctx, idx) => const Divider(height: 1),
      itemCount: products.length,
    );
  }
}
