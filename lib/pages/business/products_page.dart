import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
    const products = [];

    return ListView.separated(
      itemBuilder: (ctx, idx) => ListTile(
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
