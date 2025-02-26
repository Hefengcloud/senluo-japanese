import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_japanese_cms/pages/zengo/bloc/zengo_bloc.dart';

class ZengoDetailPage extends StatelessWidget {
  const ZengoDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ZengoBloc>(context);
    return BlocBuilder<ZengoBloc, ZengoState>(
      bloc: bloc,
      builder: (bloc, state) => const Scaffold(),
    );
  }
}
