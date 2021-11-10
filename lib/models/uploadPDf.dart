import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UploadPdf extends ChangeNotifier {
  UploadTask? uploadfile(String des, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(
        des,
      );
      return ref.putFile(file);
    } catch (e) {
      print(e);
    }
  }
}
