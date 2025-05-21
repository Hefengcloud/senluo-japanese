import 'package:senluo_common/senluo_common.dart';
import 'package:senluo_proverb/senluo_proverb.dart';

String generateProverbText(ProverbItem item) {
  String text = """
日语谚语 | ${item.name}

🔈【读音】
${item.reading}

💡【意思】
${item.meanings.map((e) => '・ $e').toList().join('\n')}
""";

  if (item.examples.isNotEmpty) {
    text += """

$kTitleExample
${item.examples.map((e) => "◎ ${e.jp}\n→ ${e.zh}").toList().join('\n')}
""";
  }
  return text;
}
