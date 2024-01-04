class Meaning {
  final List<String> jps;
  final List<String> ens;
  final List<String> zhs;

  Meaning({required this.jps, required this.ens, required this.zhs});

  String get en => ens.join(' / ');
  String get zh => ens.join(' / ');
  String get jp => ens.join(' / ');
}
