import 'package:equatable/equatable.dart';

class ContentMarketingStep extends Equatable {
  final String step;
  final String desc;
  final List<String> details;

  const ContentMarketingStep({
    required this.step,
    required this.desc,
    required this.details,
  });

  @override
  List<Object?> get props => [step, desc, details];
}
