import 'package:flutter/material.dart';

import '../../../repos/onomatopoeia/models/category_model.dart';

class OnomatopoeiaCategoryListView extends StatelessWidget {
  final int total;
  final List<OnomatopoeiaCategory> categories;
  final Function(OnomatopoeiaCategory category) onCategoryClicked;
  final OnomatopoeiaCategory selectedCategory;

  const OnomatopoeiaCategoryListView({
    super.key,
    required this.categories,
    required this.total,
    required this.onCategoryClicked,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Total: $total'),
        ),
        const Divider(),
        ListTile(
          title: const Text('全部'),
          trailing: Icon(
            selectedCategory == OnomatopoeiaCategory.empty ? Icons.check : null,
          ),
          onTap: () {
            onCategoryClicked(OnomatopoeiaCategory.empty);
          },
        ),
        ...categories.map(
          (category) => ListTile(
            title: Text(category.name),
            trailing: Icon(selectedCategory == category ? Icons.check : null),
            onTap: () {
              onCategoryClicked(category);
            },
          ),
        ),
      ],
    );
  }
}
