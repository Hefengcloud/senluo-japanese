import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';

Future<Uint8List?> captureWidget(GlobalKey globalKey) async {
  final boundary =
      globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 3.0);
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  return byteData?.buffer.asUint8List();
}

Future<void> saveImageToFile(Uint8List bytes, String fileName) async {
  // Directory appDocDir = await getApplicationDocumentsDirectory();
  // String appDocPath = appDocDir.path;
  String? outputFile = await FilePicker.platform.saveFile(
    dialogTitle: 'Save to:',
    fileName: fileName,
  );

  if (outputFile != null) {
    File file = File(outputFile);
    file.writeAsBytes(bytes);
  }
}

Future<bool> saveImageToGallery(Uint8List bytes) async {
  // Check for access premission
  final hasAccess = await Gal.hasAccess();
  if (hasAccess) {
    await Gal.putImageBytes(bytes);
    return true;
  }
  return false;
}
