import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/pages/onomatopoeia/constants/colors.dart';

import '../enums/enums.dart';

const kBrandColor = Color.fromRGBO(0x54, 0x1B, 0x1B, 1);
const kBgColor = Color.fromRGBO(0xF2, 0xE9, 0xE1, 1);

const kWeChatColor = Color(0xFF09B83E);
const kXiaoHongShuColor = Color(0xFFFF2741);
const kZhiHuColor = Color(0xFF3274EE);

const kChannel2Color = {
  DistributionChannel.none: kItemBgColor,
  DistributionChannel.weChat: kWeChatColor,
  DistributionChannel.zhiHu: kZhiHuColor,
  DistributionChannel.xiaoHongShu: kXiaoHongShuColor,
};
