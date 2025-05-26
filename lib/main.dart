import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senluo_bunpo/senluo_bunpo.dart';
import 'package:senluo_goi/senluo_goi.dart';
import 'package:senluo_japanese_cms/pages/home/home_page.dart';
import 'package:senluo_kana/repos/kana_repository.dart';
import 'package:senluo_kanji/senluo_kanji.dart';
import 'package:senluo_onomatopoeia/senluo_onomatopoeia.dart';
import 'package:senluo_proverb/senluo_proverb.dart';

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
    return MaterialApp(
      title: 'Zen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
