import '../models/meaning.dart';
import '../models/word.dart';

Word parseMeaning(String str) {
  // Split the string by the separator '（' and '）' to extract the substring between them
  List<String> parts = str.split('（');
  String text = parts.first; // Extracts '支店'

  // Extracting the substring 'してん' from the second part
  String reading = parts.length > 1 ? parts[1].split('）').first : '';

  // Extracting 'branch store / branch office' after the separator '：'
  List<String> lastPart = str.split('：');
  String meaning = lastPart.length > 1 ? lastPart.last : '';
  final ens = meaning.split('/').map((e) => e.trim()).toList();

  return Word(
    text: text,
    reading: reading,
    meaning: Meaning(jps: [], ens: ens, zhs: []),
  );
}
