import '../../../common/enums/enums.dart';

class ProductItem {
  final String name;
  final String desc;
  final ProductType type;
  final String url;

  const ProductItem({
    required this.name,
    required this.desc,
    required this.type,
    required this.url,
  });
}
