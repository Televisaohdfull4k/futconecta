import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesRepository {
  FavoritesRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  String _favoriteId(String clubId, String playerId) => '${clubId}_$playerId';

  Stream<Set<String>> watchFavoritePlayerIds(String clubId) {
    return _firestore
        .collection('favorites')
        .where('clubId', isEqualTo: clubId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => doc.data()['playerId'] as String)
              .toSet();
        });
  }

  Future<void> toggleFavorite({
    required String clubId,
    required String playerId,
    required bool isFavorite,
  }) async {
    final doc = _firestore
        .collection('favorites')
        .doc(_favoriteId(clubId, playerId));
    if (isFavorite) {
      await doc.delete();
      return;
    }
    await doc.set({
      'id': doc.id,
      'clubId': clubId,
      'playerId': playerId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
