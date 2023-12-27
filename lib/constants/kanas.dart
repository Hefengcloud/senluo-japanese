enum KanaLine {
  none([]),
  a(['あ', 'い', 'う', 'え', 'お']),
  ka(['か', 'き', 'く', 'け', 'こ']),
  sa(['さ', 'し', 'す', 'せ', 'そ']),
  ta(['た', 'ち', 'つ', 'て', 'と']),
  na(['な', 'に', 'ぬ', 'ね', 'の']),
  ha(['は', 'ひ', 'ふ', 'へ', 'ほ']),
  ma(['ま', 'み', 'む', 'め', 'も']),
  ya(['や', 'ゆ', 'よ']),
  ra(['ら', 'り', 'る', 'れ', 'ろ']),
  wa(['わ', 'を']);

  final List<String> kanas;

  String get name => kanas.isNotEmpty ? kanas.first : '';

  const KanaLine(this.kanas);
}
