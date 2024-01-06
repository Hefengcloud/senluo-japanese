import 'package:senluo_japanese_cms/repos/grammars/models/grammar_item.dart';

import '../../../constants/texts.dart';
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
${examples.map((e) => "◎ ${e.jp.replaceAll('**', '')}\n→ ${e.zh.replaceAll('**', '').replaceAll(' ', '')}").toList().join('\n\n')}
""";

  List<String> parseName() {
    RegExp regex = RegExp(r'（([^（）]+)）');
    Match? match = regex.firstMatch(name);
    final String itemName = name.replaceAll(regex, '');
    if (match != null) {
      return [itemName, match.group(1)!];
    } else {
      return [itemName];
    }
  }

  get jpMeaningText => joinLinesToText(meaning.jps);

  get cnMeaningText => joinLinesToText(meaning.zhs);

  get conjugationText => joinLinesToText(conjugations);

  get explainationText => joinLinesToText(explanations);
}

joinLinesToText(List<String> lines) => lines.map((e) => '・$e').join('\n');
