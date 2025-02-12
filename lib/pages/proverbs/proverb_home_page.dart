import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/common/constants/kanas.dart';
import 'package:senluo_japanese_cms/pages/proverbs/proverb_details_page.dart';

import '../../repos/proverbs/models/proverb_item.dart';
import 'bloc/proverb_bloc.dart';

class ProverbHomePage extends StatefulWidget {
  const ProverbHomePage({super.key});

  @override
  State<ProverbHomePage> createState() => _ProverbHomePageState();
}

class _ProverbHomePageState extends State<ProverbHomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      final keyword = _searchController.text.trim();
      BlocProvider.of<ProverbBloc>(context)
          .add(ProverbSearched(keyword: keyword));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProverbBloc, ProverbState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(state),
          endDrawer: state is ProverbLoaded ? _buildDrawer(state) : null,
        );
      },
    );
  }

  _buildDrawer(ProverbLoaded state) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Text('ことわざ'),
          ),
          ...KanaLine.values.map<ListTile>((line) {
            return ListTile(
              trailing: line == state.currentKanaLine
                  ? const Icon(Icons.check)
                  : null,
              title: Text("${line != KanaLine.none ? line.name : '全部'} 行"),
              onTap: () {
                BlocProvider.of<ProverbBloc>(context)
                    .add(ProverbFiltered(kanaLine: line));
                Navigator.of(context).pop();
              },
            );
          }),
        ],
      ),
    );
  }

  _buildBody(ProverbState state) {
    if (state is ProverbLoading) {
      return _buildLoading(context);
    } else if (state is ProverbLoaded) {
      return _buildProverbList(context, state);
    }
  }

  _buildAppBar() {
    return AppBar(
      title: const Text("ことわざ"),
    );
  }

  _buildSearchAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      leading: const Icon(
        Icons.search,
        color: Colors.white,
      ),
      title: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: const InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.white54),
          border: InputBorder.none,
        ),
      ),
    );
  }

  _buildLoading(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  _buildProverbList(BuildContext context, ProverbLoaded state) {
    final bloc = BlocProvider.of<ProverbBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: state.items
            .mapIndexed<Widget>(
              (index, item) => InkWell(
                onTap: () {
                  bloc.add(ProverbSelected(item: item));
                  _showProverbDetails(context, item);
                },
                child: ListTile(
                  title: Text(
                    item.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(item.meanings.join(';')),
                  trailing: const Icon(Icons.arrow_right),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  _showProverbDetails(BuildContext context, ProverbItem item) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => ProverbDetailsPage(proverb: item)),
    );
  }
}

enum ProverbCategory {
  digit,
  animal,
  body,
}
