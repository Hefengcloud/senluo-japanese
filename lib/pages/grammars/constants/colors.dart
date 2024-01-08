import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:senluo_japanese_cms/common/enums/jlpt_level.dart';

const kColorN1 = Color(0xFFEB2B92);
const kColorN2 = Color(0xFFFA9817);
const kColorN3 = Color(0xFF86C129);
const kColorN4 = Color(0xFF45A099);
const kColorN5 = Color(0xFF3474BC);
const kColorN0 = Colors.purple;

const Map<JLPTLevel, Color> kLevel2color = {
  JLPTLevel.n1: kColorN1,
  JLPTLevel.n2: kColorN2,
  JLPTLevel.n3: kColorN3,
  JLPTLevel.n4: kColorN4,
  JLPTLevel.n5: kColorN5,
  JLPTLevel.n0: kColorN0,
};
