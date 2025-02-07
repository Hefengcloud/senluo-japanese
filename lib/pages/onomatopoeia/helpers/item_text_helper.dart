import '../../../common/constants/texts.dart';
import '../../../repos/onomatopoeia/models/onomatopoeia_models.dart';
import '../../grammars/constants/texts.dart';

String generateFullText(Onomatopoeia item) {
  return """
拟声拟态词 | ${item.name}

$kTitleZhMeaning
${item.meanings['zh']?.map((e) => '- $e').toList().join('\n')}

$kTitleEnMeaning
${item.meanings['en']?.map((e) => '- $e').toList().join('\n')}

$kTitleJpMeaning
${item.meanings['jp']?.map((e) => '- $e').toList().join('\n')}

$kTitleExample
${item.examples.map((e) => "◎ ${e['jp']}\n→ ${e['zh']}\n→ ${e['en']}\n").toList().join('\n')}
""";
}

String generateChineseText(Onomatopoeia item) {
  return """
拟声拟态词 | ${item.name}

$kTitleZhMeaning
${item.meanings['zh']?.map((e) => '- $e').toList().join('\n')}

$kTitleJpMeaning
${item.meanings['jp']?.map((e) => '- $e').toList().join('\n')}

$kTitleExample
${item.examples.map((e) => "◎ ${e['jp']}\n→ ${e['zh']}\n").toList().join('\n')}
""";
}
