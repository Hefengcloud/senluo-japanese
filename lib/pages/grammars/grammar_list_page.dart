import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_bunpo/senluo_bunpo.dart';
import 'package:senluo_common/senluo_common.dart';
import 'package:senluo_japanese_cms/pages/grammars/bloc/grammar_bloc.dart';
import 'package:senluo_japanese_cms/pages/grammars/grammar_details_page.dart';

class GrammarListPage extends StatelessWidget {
  const GrammarListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrammarBloc, GrammarState>(
      buildWhen: (previous, current) =>
          current is GrammarLoaded && current.currentLevel != JLPTLevel.none,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: state is GrammarLoaded
                ? Text(
                    '${state.currentLevel.name.toUpperCase()} 文法',
                    style: TextStyle(color: state.currentLevel.color),
                  )
                : const CircularProgressIndicator(),
          ),
          body: state is GrammarLoaded
              ? ListView(
                  children: state.currentLevelEntries.mapIndexed<ListTile>(
                    (idx, e) {
                      return ListTile(
                        leading: Text(
                          (idx + 1).toString().padLeft(3, '0'),
                          style: TextStyle(
                            color: state.currentLevel.color,
                          ),
                        ),
                        title: Text(e.name),
                        onTap: () => _gotoDetail(context, e),
                      );
                    },
                  ).toList(),
                )
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  _gotoDetail(BuildContext context, GrammarEntry entry) {
    context.read<GrammarBloc>().add(GrammarEntryChanged(entry: entry));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RepositoryProvider(
          create: (BuildContext context) =>
              BlocProvider.of<GrammarBloc>(context).grammarRepository,
          child: GrammarDetailsPage(entry: entry),
        ),
      ),
    );
  }
}
