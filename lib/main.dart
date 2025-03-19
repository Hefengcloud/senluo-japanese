import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_bunpo/senluo_bunpo.dart';
import 'package:senluo_japanese_cms/pages/home/home_page.dart';
import 'package:senluo_japanese_cms/pages/kanji/bloc/kanji_bloc.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/bloc/onomatopoeia_bloc.dart';
import 'package:senluo_japanese_cms/pages/proverbs/bloc/proverb_bloc.dart';
import 'package:senluo_japanese_cms/pages/vocabulary/bloc/vocabulary_bloc.dart';
import 'package:senluo_japanese_cms/repos/gojuon/kana_repository.dart';
import 'package:senluo_japanese_cms/repos/kanji/kanji_repository.dart';
import 'package:senluo_japanese_cms/repos/onomatopoeia/onomatopoeia_repository.dart';
import 'package:senluo_japanese_cms/repos/proverbs/proverb_repository.dart';
import 'package:senluo_japanese_cms/repos/vocabulary/vocabulary_repository.dart';

import 'pages/grammars/bloc/grammar_bloc.dart';
import 'pages/kana/bloc/kana_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final grammarRepo = GrammarRepository();
  final proverbRepo = ProverbRepository();
  final kanaRepo = KanaRepository();
  final onomatopoeiaRepo = OnomatopoeiaRepository();
  final kanjiRepo = KanjiRepository();
  final vocabularyRepo = VocabularyRepository();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GrammarBloc(grammarRepository: grammarRepo)
            ..add(GrammarStarted()),
        ),
        BlocProvider(
          create: (_) => ProverbBloc(proverbRepository: proverbRepo)
            ..add(ProverbStarted()),
        ),
        BlocProvider(
          create: (_) => KanaBloc(kanaRepo: kanaRepo)..add(const KanaStarted()),
        ),
        BlocProvider(
          create: (_) =>
              OnomatopoeiaBloc(onomatopoeiaRepo)..add(OnomatopoeiaStarted()),
        ),
        BlocProvider(
          create: (_) => KanjiBloc(kanjiRepo)..add(KanjiStarted()),
        ),
        BlocProvider(
          create: (_) =>
              VocabularyBloc(vocabularyRepo)..add(VocabularyStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'SENLUO JAPANESE',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}
