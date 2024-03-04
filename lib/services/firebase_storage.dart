import 'dart:ffi';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<firebase_storage.ListResult> getImages() async {
    firebase_storage.ListResult images =
        await storage.ref('events_pictures').listAll();

    return images;
  }
}
