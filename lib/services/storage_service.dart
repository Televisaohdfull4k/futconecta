import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  StorageService({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Future<String> uploadProfilePhoto(String userId, File file) async {
    final ref = _storage.ref('players/$userId/profile.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  Future<String> uploadPlayerVideo(String playerId, File file) async {
    final name = DateTime.now().millisecondsSinceEpoch;
    final ref = _storage.ref('players/$playerId/videos/$name.mp4');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }
}
