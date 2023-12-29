import 'package:flutter/material.dart';

import '../../../repos/onomatopoeia/models/category_model.dart';

class CategoryListView extends StatefulWidget {
  final int total;
  final List<OnomatopoeiaCategory> categories;
  final Function(OnomatopoeiaCategory category) onCategoryClicked;

  const CategoryListView({
    super.key,
    required this.categories,
    required this.total,
    required this.onCategoryClicked,
  });

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  OnomatopoeiaCategory _category = OnomatopoeiaCategory.empty;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Total: ${widget.total}'),
        ),
        const Divider(),
        ListTile(
          title: const Text('全部'),
          trailing: Icon(
            _category == OnomatopoeiaCategory.empty ? Icons.check : null,
          ),
          onTap: () {
            setState(() {
              _category = OnomatopoeiaCategory.empty;
            });
            widget.onCategoryClicked(OnomatopoeiaCategory.empty);
          },
        ),
        ...widget.categories
            .map(
              (category) => ListTile(
                title: Text(category.name),
                trailing: Icon(_category == category ? Icons.check : null),
                onTap: () {
                  setState(() {
                    _category = category;
                  });
                  widget.onCategoryClicked(category);
                },
              ),
            )
            .toList(),
      ],
    );
  }
}
