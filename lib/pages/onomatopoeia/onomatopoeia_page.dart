import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/categories_view.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/item_list_view.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/widgets/onomatopoeia_card.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/category_model.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/models/onomatopoeia_models.dart';

import 'bloc/onomatopoeia_bloc.dart';

class OnomatopoeiaPage extends StatefulWidget {
  const OnomatopoeiaPage({super.key});

  @override
  State<OnomatopoeiaPage> createState() => _OnomatopoeiaPageState();
}

class _OnomatopoeiaPageState extends State<OnomatopoeiaPage> {
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
        Expanded(flex: 1, child: _buildLeftPanel(context, state)),
        const VerticalDivider(width: 1.0),
        Expanded(flex: 3, child: _buildRightPanel(context, state)),
      ],
    );
  }

  _buildLeftPanel(BuildContext context, OnomatopoeiaState state) {
    if (state is OnomatopoeiaLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is OnomatopoeiaLoaded) {
      final bloc = BlocProvider.of<OnomatopoeiaBloc>(context);
      return ListView(
        children: [
          ListTile(
            title: Text('Total: ${state.items.length}'),
          ),
          Divider(),
          ListTile(
            title: Text('All'),
            onTap: () => bloc.add(const OnomatopoeiaFiltered(
              category: OnomatopoeiaCategory.empty,
            )),
          ),
          ...state.categories
              .map<ListTile>(
                (category) => ListTile(
                  title: Text(category.name),
                  onTap: () =>
                      bloc.add(OnomatopoeiaFiltered(category: category)),
                ),
              )
              .toList(),
        ],
      );
    }
  }

  _buildRightPanel(BuildContext context, OnomatopoeiaState state) {
    if (state is OnomatopoeiaLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is OnomatopoeiaLoaded) {
      return ItemListView(items: state.items);
    }
  }
}
