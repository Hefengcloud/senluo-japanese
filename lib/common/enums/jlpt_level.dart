enum JLPTLevel {
  n1,
  n2,
  n3,
  n4,
  n5,
  n0,
  none;

  factory JLPTLevel.fromString(String value) {
    return JLPTLevel.values.firstWhere(
      (level) => level.toString().split('.').last == value.toLowerCase(),
      orElse: () => JLPTLevel.n0,
    );
  }
}
