import 'package:equatable/equatable.dart';
import 'package:yaml/yaml.dart';

typedef Example = Map<String, String>;
typedef Meaning = Map<String, List<String>>;

class Onomatopoeia extends Equatable {
  final String key;
  final String name;
  final Meaning meanings;
  final List<Example> examples;

  const Onomatopoeia({
    required this.key,
    required this.name,
    required this.meanings,
    required this.examples,
  });

  String get theName => name.split('/').map<String>((e) => e.trim()).join('\n');

  factory Onomatopoeia.fromYamlMap(YamlMap yamlMap) {
    final key = yamlMap['key'];
    final name = yamlMap['name'];
    final meaningMap = yamlMap['meanings'];
    final Meaning meanings = {
      'jp': meaningMap['jp']?.map<String>((e) => e.toString()).toList() ?? [],
      'en': meaningMap['en']?.map<String>((e) => e.toString()).toList() ?? [],
      'zh': meaningMap['zh']?.map<String>((e) => e.toString()).toList() ?? [],
    };
    final examples = yamlMap['examples']
        .map<Example>((e) => <String, String>{
              'jp': e['jp'].toString(),
              'en': e['en'].toString().replaceAll('**', ''),
              'zh': e['zh'].toString(),
            })
        .toList();
    return Onomatopoeia(
      key: key,
      name: name,
      meanings: meanings,
      examples: examples,
    );
  }

  @override
  List<Object?> get props => [key, name, meanings, examples];
}
