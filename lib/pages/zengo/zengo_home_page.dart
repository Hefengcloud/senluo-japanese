import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/pages/zengo/bloc/zengo_bloc.dart';
import 'package:senluo_japanese_cms/pages/zengo/zengo_detail_page.dart';
import 'package:senluo_japanese_cms/repos/zengo/zengo_repository.dart';

import '../../repos/zengo/models/zengo_item.dart';

class ZengoHomePage extends StatelessWidget {
  ZengoHomePage({super.key});

  final _repo = ZengoRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ZengoBloc>(
      create: (ctx) => ZengoBloc(),
      child: BlocBuilder<ZengoBloc, ZengoState>(
        builder: (ctx, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('禅語'),
            ),
            body: _buildBody(ctx),
          );
        },
      ),
    );
  }

  _buildBody(BuildContext ctx) {
    return FutureBuilder(
      future: _repo.loadZengos(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildZengoList(ctx, snapshot.data!);
      },
    );
  }

  _buildZengoList(BuildContext context, List<ZengoCategory> zengos) {
    return ListView(
      children: zengos
          .map(
            (ZengoCategory e) => ExpansionTile(
              title: Text(e.name),
              children: e.items
                  .map(
                    (e) => ListTile(
                      leading: const Icon(Icons.arrow_right),
                      title: Text(e.lines.join(' ')),
                      subtitle: Text(e.meaning),
                      onTap: () {
                        context
                            .read<ZengoBloc>()
                            .add(ZengoItemChanged(item: e));
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<ZengoBloc>(),
                              child: const ZengoDetailPage(),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }
}
