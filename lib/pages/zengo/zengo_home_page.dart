import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/pages/zengo/bloc/zengo_bloc.dart';
import 'package:senluo_japanese_cms/pages/zengo/zengo_detail_page.dart';
import 'package:senluo_japanese_cms/repos/zengo/zengo_repository.dart';

import '../../repos/zengo/models/zengo_item.dart';

class ZengoHomePage extends StatelessWidget {
  const ZengoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ZengoBloc>(
      create: (ctx) => ZengoBloc(ZengoRepository())..add(ZengoStarted()),
      child: BlocBuilder<ZengoBloc, ZengoState>(
        builder: (ctx, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('禅語'),
            ),
            body: state is ZengoLoaded
                ? _buildBody(ctx, state)
                : const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  _buildBody(BuildContext ctx, ZengoLoaded state) {
    return _buildZengoList(ctx, state.items);
  }

  _buildZengoList(BuildContext context, List<Zengo> items) {
    return ListView(
      children: items
          .mapIndexed(
            (idx, e) => ListTile(
              leading: const Icon(Icons.arrow_right),
              title: Text(e.lines.join(' ')),
              subtitle: Text(e.meaning),
              onTap: () {
                context.read<ZengoBloc>().add(ZengoItemChanged(item: e));
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<ZengoBloc>(),
                      child: ZengoDetailPage(initialIndex: idx),
                    ),
                  ),
                );
              },
            ),
          )
          .toList(),
    );
  }
}
