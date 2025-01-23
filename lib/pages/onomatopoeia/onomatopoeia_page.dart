import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_grid_view.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';

import 'bloc/onomatopoeia_bloc.dart';
import 'widgets/category_list_view.dart';

class OnomatopoeiaHomePage extends StatefulWidget {
  const OnomatopoeiaHomePage({super.key});

  @override
  State<OnomatopoeiaHomePage> createState() => _OnomatopoeiaHomePageState();
}

class _OnomatopoeiaHomePageState extends State<OnomatopoeiaHomePage> {
  Onomatopoeia? onomatopoeia;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnomatopoeiaBloc, OnomatopoeiaState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('オノマトペ')),
          body: _buildBody(context, state),
        );
      },
    );
  }

  _buildBody(BuildContext context, OnomatopoeiaState state) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: _buildLeftPanel(context, state),
        ),
        const VerticalDivider(width: 1.0),
        Expanded(
          child: _buildRightPanel(context, state),
        ),
      ],
    );
  }

  _buildLeftPanel(BuildContext context, OnomatopoeiaState state) {
    if (state is OnomatopoeiaLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is OnomatopoeiaLoaded) {
      final bloc = BlocProvider.of<OnomatopoeiaBloc>(context);
      return CategoryListView(
        categories: state.categories,
        total: state.items.length,
        onCategoryClicked: (category) =>
            bloc.add(OnomatopoeiaFiltered(category: category)),
        selectedCategory: state.currentCategory,
      );
    }
  }

  _buildRightPanel(BuildContext context, OnomatopoeiaState state) {
    if (state is OnomatopoeiaLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is OnomatopoeiaLoaded) {
      return ItemGridView(items: state.items);
    }
  }
}
