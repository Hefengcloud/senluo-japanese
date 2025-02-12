import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/onomatopoeia_list_view.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';

import 'bloc/onomatopoeia_bloc.dart';
import 'widgets/onomatopoeia_category_list_view.dart';

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
          endDrawer: state is OnomatopoeiaLoaded ? _buildDrawer(state) : null,
          body: _buildBody(state),
        );
      },
    );
  }

  _buildDrawer(OnomatopoeiaLoaded state) {
    return Drawer(
      child: OnomatopoeiaCategoryListView(
        categories: state.categories,
        total: state.items.length,
        onCategoryClicked: (category) {
          BlocProvider.of<OnomatopoeiaBloc>(context)
              .add(OnomatopoeiaFiltered(category: category));
          Navigator.of(context).pop();
        },
        selectedCategory: state.currentCategory,
      ),
    );
  }

  _buildBody(OnomatopoeiaState state) {
    if (state is OnomatopoeiaLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is OnomatopoeiaLoaded) {
      return OnomatopoeiaListView(items: state.items);
    }
  }
}
