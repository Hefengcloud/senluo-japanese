import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:gal/gal.dart';
import 'package:unsplash_client/unsplash_client.dart';

final unsplashClient = UnsplashClient(
  settings: const ClientSettings(
    credentials: AppCredentials(
        accessKey: 'd-i9E1tPZHVotRUma2Nh8rncfU5J6JTsEQmFUVFcsKQ',
        secretKey: 'rpYml2PR5nhwaOtftymCYM5l-Jc25xrwjT1GbsQUq2g'),
  ),
);

Future<Uint8List?> captureWidget(GlobalKey globalKey) async {
  final boundary =
      globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 3.0);
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  return byteData?.buffer.asUint8List();
}

Future<void> saveImage(Uint8List bytes, String fileName) async {
  if (Device.get().isPhone) {
    saveImageToGallery(bytes);
  } else {
    saveImageToFile(bytes, fileName);
  }
}

Future<void> saveImageToFile(Uint8List bytes, String fileName) async {
  // Directory appDocDir = await getApplicationDocumentsDirectory();
  // String appDocPath = appDocDir.path;
  String? outputFile = await FilePicker.platform.saveFile(
    dialogTitle: 'Save to:',
    fileName: fileName,
  );

  File file = File(outputFile!);
  file.writeAsBytes(bytes);
}

Future<bool> saveImageToGallery(Uint8List bytes) async {
  // Check for access premission
  final hasAccess = await Gal.hasAccess();
  if (!hasAccess) {
    final requested = await Gal.requestAccess();
    if (!requested) {
      return false;
    }
  }
  await Gal.putImageBytes(bytes);
  return true;
}
