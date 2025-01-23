import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTitle extends Text {
  AppTitle({super.key})
      : super(
          '森罗日语',
          style: GoogleFonts.getFont(
            'Zhi Mang Xing',
            fontSize: 20,
            color: Colors.purple,
          ),
        );
}
