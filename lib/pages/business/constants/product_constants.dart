import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/common/enums/enums.dart';
import 'package:senluo_japanese_cms/repos/business/models/product_item.dart';

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
        return Icons.paid;
    }
  }
}

const kMyProducts = [
  ProductItem(
    name: '日语五十音【App】',
    desc: '面向「日语初学者」的日语自学工具',
    type: ProductType.app,
    url: 'https://senluoshe/apps/gojuon',
  ),
  ProductItem(
    name: '日语语法速查【App】',
    desc: '面向「JLPT备考者」的效率工具',
    type: ProductType.app,
    url: 'https://senluoshe/apps/bunpo',
  ),
  ProductItem(
    name: '森罗日语【小程序】',
    desc: '提升公众号内「日语」内容的交互性',
    type: ProductType.miniProgram,
    url: 'https://senluoshe/miniprogram/senluoriyu',
  ),
  ProductItem(
    name: '和风历史辞典【小程序】',
    desc: '提升公众号内「历史」内容的交互性',
    type: ProductType.miniProgram,
    url: 'https://senluoshe/miniprogram/senluoriyu',
  ),
  ProductItem(
    name: '简明日语语法教程【电子书】',
    desc: '日语系统文法教程',
    type: ProductType.eBook,
    url: 'https://senluoshe/tutorials/concise-bunpo',
  ),
  ProductItem(
    name: '日语JLPT语法精讲【线上课程】',
    desc: '日语JLPT文法教程',
    type: ProductType.onlineCourse,
    url: 'https://senluoshe/tutorials/concise-bunpo',
  ),
  ProductItem(
    name: '生活日语【付费专栏】',
    desc: '生活中常用的实用日语',
    type: ProductType.paidNewsletter,
    url: 'https://senluoshe/tutorials/concise-bunpo',
  ),
];
