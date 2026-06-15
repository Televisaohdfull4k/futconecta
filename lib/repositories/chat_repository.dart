import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  ChatRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  String conversationId(String a, String b) {
    final ids = [a, b]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchMessages({
    required String currentUserId,
    required String receiverId,
  }) {
    final chatId = conversationId(currentUserId, receiverId);
    return _firestore
        .collection('messages')
        .where('conversationId', isEqualTo: chatId)
        .orderBy('data')
        .snapshots();
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String texto,
  }) async {
    final chatId = conversationId(senderId, receiverId);
    await _firestore.collection('messages').add({
      'senderId': senderId,
      'receiverId': receiverId,
      'texto': texto.trim(),
      'data': FieldValue.serverTimestamp(),
      'conversationId': chatId,
      'participants': [senderId, receiverId],
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchConversations(
    String userId,
  ) {
    return _firestore
        .collection('messages')
        .where('participants', arrayContains: userId)
        .orderBy('data', descending: true)
        .snapshots();
  }
}
