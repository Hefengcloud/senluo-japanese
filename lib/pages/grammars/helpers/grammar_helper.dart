import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

import '../constants/texts.dart';

extension GrammarItemX on GrammarItem {
  get text => """
$level文法 | $name

$kTitleJpMeaning
$jpMeaningText

$kTitleZhMeaning
$cnMeaningText

$kTitleConjugations
$conjugationText

$kTitleExample
${examples.map((e) => "◎ ${e.jp.replaceAll('**', '')}\n→ ${e.cn.replaceAll('**', '').replaceAll(' ', '')}").toList().join('\n\n')}
""";

  get jpMeaningText => joinLinesToText(meaning.jp);

  get cnMeaningText => joinLinesToText(meaning.cn);

  get conjugationText => joinLinesToText(conjugations);

  get explainationText => joinLinesToText(explanations);
}

joinLinesToText(List<String> lines) => lines.map((e) => '・$e').join('\n');
