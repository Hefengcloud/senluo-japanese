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

// Senluo Japanese 配色方案
class SenluoColors {
  // 主色 - 和风青（Gentle Green）
  static const Color primary = Color(0xFF4CAF50);

  // 次要色 - 樱花粉（Sakura Pink）
  static const Color secondary = Color(0xFFF48FB1);

  // 强调色 - 夕阳橙（Sunset Orange）
  static const Color accent = Color(0xFFFF9800);

  // 背景色 - 米白色（Ivory White）
  static const Color background = Color(0xFFFAF7F0);

  // 文字颜色
  static const Color textPrimary = Color(0xFF333333); // 深灰色 - 主文字
  static const Color textSecondary = Color(0xFF757575); // 中灰色 - 次要文字

  // 边框与分割线色 - 浅灰色
  static const Color border = Color(0xFFE0E0E0);
}

// 主题数据扩展（可选，用于 MaterialApp 的主题）
class SenluoTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: const Color.fromRGBO(76, 175, 80, 1), // 主色
      colorScheme: ColorScheme.light(
        primary: SenluoColors.primary,
        secondary: SenluoColors.secondary,
        tertiary: SenluoColors.accent,
        background: SenluoColors.background,
      ),
      scaffoldBackgroundColor: SenluoColors.background, // 页面背景
      appBarTheme: AppBarTheme(
        backgroundColor: SenluoColors.primary, // 导航栏背景
        titleTextStyle: TextStyle(
          color: SenluoColors.textPrimary, // 导航栏文字颜色
          fontSize: 20,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: SenluoColors.textPrimary), // 主文字
        bodyMedium: TextStyle(color: SenluoColors.textSecondary), // 次要文字
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: SenluoColors.accent, // 按钮默认颜色
        textTheme: ButtonTextTheme.primary,
      ),
      dividerColor: SenluoColors.border, // 分割线颜色
      cardColor: SenluoColors.background, // 卡片背景
    );
  }

  // 可选：暗黑模式主题
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: SenluoColors.primary,
      colorScheme: ColorScheme.dark(
        primary: SenluoColors.primary,
        secondary: SenluoColors.secondary,
        tertiary: SenluoColors.accent,
        background: Colors.grey[900]!, // 深灰色背景
      ),
      scaffoldBackgroundColor: Colors.grey[900]!,
      appBarTheme: AppBarTheme(
        backgroundColor: SenluoColors.primary,
        titleTextStyle: TextStyle(
          color: SenluoColors.textPrimary,
          fontSize: 20,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: SenluoColors.textPrimary),
        bodyMedium: TextStyle(color: SenluoColors.textSecondary),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: SenluoColors.accent,
      ),
      dividerColor: Colors.grey[800]!,
      cardColor: Colors.grey[850]!,
    );
  }
}
