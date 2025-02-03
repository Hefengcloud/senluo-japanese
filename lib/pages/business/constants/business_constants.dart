import 'package:tuple/tuple.dart';

enum BusinessPart {
  leadership("Leadership"),
  products("Products"),
  marketing("Marketing"),
  sales("Sales"),
  overheadAndOperations("Overhead & Operations"),
  cashFlow("Cash Flow");

  const BusinessPart(this.value);
  final String value;
}

class BusinessConstants {
  static const vision = '用科技与文化\n打造最懂语言的学习家园';
  static const mission = '通过打造科技感十足的产品\n并创作融合历史文化视角的内容\n助力日语学习者以更科学的方式掌握日语';
  static const values = [
    Tuple2("利他", "Altruism"),
    Tuple2("真诚", "Sincerity"),
    Tuple2("创新", "Innovation"),
    Tuple2("高效", "Efficiency"),
  ];
}
