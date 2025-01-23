import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/expressions/views/expression_category_list_view.dart';
import 'package:senluo_japanese_cms/pages/expressions/views/expression_item_grid_view.dart';

class ExpressionHomePage extends StatelessWidget {
  const ExpressionHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('表現')),
      body: const Row(
        children: [
          Expanded(
            flex: 1,
            child: ExpressionCategoryListView(),
          ),
          Expanded(
            flex: 5,
            child: ExpressionItemGridView(),
          ),
        ],
      ),
    );
  }
}
