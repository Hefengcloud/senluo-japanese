import 'package:senluo_japanese_cms/pages/jlpt/constants/texts.dart';
import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

extension GrammarItemX on GrammarItem {
  get text => "$kTitleJpMeaning\n\n$jpMeaningText\n\n"
      "$kTitleCnMeaning\n\n$cnMeaningText\n\n"
      "$kTitleConjugations\n\n$conjugationText\n\n"
      "$kTitleExplanation\n\n$explainationText\n\n";

  get jpMeaningText => joinLinesToText(jpMeanings);

  get cnMeaningText => joinLinesToText(cnMeanings);

  get conjugationText => joinLinesToText(conjugations);

  get explainationText => joinLinesToText(explanation);
}

joinLinesToText(List<String> lines) => lines.map((e) => '・$e').join('\n');
