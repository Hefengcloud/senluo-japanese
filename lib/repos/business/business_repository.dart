import 'package:flutter/services.dart';
import 'package:senluo_japanese_cms/repos/business/models/content_marketing_step.dart';
import 'package:yaml/yaml.dart';

class BusinessRepository {
  static const _kContentMarketingFile =
      'assets/business/content-marketing-steps.yaml';

  Future<List<ContentMarketingStep>> loadContentMarketingSteps() async {
    final yamlString = await rootBundle.loadString(_kContentMarketingFile);
    final stepsInYaml = loadYaml(yamlString);
    final steps = stepsInYaml
        .map<ContentMarketingStep>(
          (e) => ContentMarketingStep(
            step: e['step'].toString(),
            desc: e['desc'].toString(),
            details: e['details'].map<String>((e) => e.toString()).toList(),
          ),
        )
        .toList();
    return steps;
  }
}
