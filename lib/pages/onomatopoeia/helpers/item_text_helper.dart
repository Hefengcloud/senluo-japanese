import 'package:senluo_onomatopoeia/senluo_onomatopoeia.dart';

String generateFullText(Onomatopoeia item) {
  return """
拟声拟态词 | ${item.name}

【中文意思】
${item.meanings['zh']?.map((e) => '- $e').toList().join('\n')}

【英文意思】
${item.meanings['en']?.map((e) => '- $e').toList().join('\n')}

【日文意思】
${item.meanings['jp']?.map((e) => '- $e').toList().join('\n')}

【例句】
${item.examples.map((e) => "◎ ${e['jp']}\n→ ${e['zh']}\n→ ${e['en']}\n").toList().join('\n')}
""";
}
