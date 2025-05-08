import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/common/enums/enums.dart';

extension ProductTypeIcon on ProductType {
  IconData get icon {
    switch (this) {
      case ProductType.website:
        return Icons.web_outlined;
      case ProductType.app:
        return Icons.phone_iphone_outlined;
      case ProductType.miniProgram:
        return Icons.wechat_outlined;
      case ProductType.eBook:
        return Icons.book_online_outlined;
      case ProductType.onlineCourse:
        return Icons.school_outlined;
      case ProductType.paidNewsletter:
        return Icons.paid_outlined;
      case ProductType.podcast:
        return Icons.podcasts_outlined;
    }
  }
}

const kMyProducts = [];
