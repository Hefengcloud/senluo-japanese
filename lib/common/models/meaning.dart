import 'package:collection/collection.dart';
import 'package:senluo_common/senluo_common.dart';

import '../constants/number_constants.dart';

class Meaning {
  final List<String> jps;
  final List<String> ens;
  final List<String> zhs;

  const Meaning({
    required this.jps,
    required this.ens,
    required this.zhs,
  });

  String get en => ens.join(' / ');
  String get zh => zhs.length > 1
      ? zhs.mapIndexed((idx, e) => "${solidMaruNumbers[idx]}$e").join(' ')
      : zhs.first;
  String get jp => jps.length > 1
      ? jps.mapIndexed((idx, e) => "${maruNumbers[idx]}$e").join(' ')
      : jps.first;

  static const empty = Meaning(jps: [], ens: [], zhs: []);
}
