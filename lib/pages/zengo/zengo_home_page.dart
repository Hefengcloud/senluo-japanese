import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/repos/zengo/zengo_repository.dart';

import '../../repos/zengo/models/zengo_item.dart';

class ZengoHomePage extends StatelessWidget {
  ZengoHomePage({super.key});

  final _repo = ZengoRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('禅語'),
      ),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return FutureBuilder(
      future: _repo.loadZengos(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildZengoList(snapshot.data!);
      },
    );
  }

  _buildZengoList(List<ZengoCategory> zengos) {
    return ListView(
      children:
          zengos.map<ListTile>((e) => ListTile(title: Text(e.name))).toList(),
    );
  }
}
