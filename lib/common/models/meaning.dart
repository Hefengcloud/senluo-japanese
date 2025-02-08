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
  String get zh => zhs.join(' / ');
  String get jp => jps.join(' / ');

  static const empty = Meaning(jps: [], ens: [], zhs: []);
}
