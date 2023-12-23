import 'package:senluo_japanese_cms/pages/jlpt/constants/texts.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

extension GrammarItemX on GrammarItem {
  get text => "$kTitleJpMeaning\n\n$jpMeaningText\n\n"
      "$kTitleCnMeaning\n\n$cnMeaningText\n\n"
      "$kTitleConjugations\n\n$conjugationText\n\n"
      "$kTitleExplanation\n\n$explainationText\n\n";

  get jpMeaningText => joinLinesToText(meaning.jp);

  get cnMeaningText => joinLinesToText(meaning.cn);

  get conjugationText => joinLinesToText(conjugations);

  get explainationText => joinLinesToText(explanations);
}

joinLinesToText(List<String> lines) => lines.map((e) => '・$e').join('\n');
