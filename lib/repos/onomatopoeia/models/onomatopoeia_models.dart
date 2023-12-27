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

  factory Onomatopoeia.fromYamlMap(YamlMap yamlMap) {
    final key = yamlMap['key'];
    final name = yamlMap['name'];
    final Meaning meanings = {
      'jp': yamlMap['meanings']['jp'].map<String>((e) => e.toString()).toList(),
      'en': yamlMap['meanings']['en'].map<String>((e) => e.toString()).toList(),
    };
    final examples = yamlMap['examples']
        .map<Example>((e) => <String, String>{
              'jp': e['jp'].toString(),
              'en': e['en'].toString(),
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
