import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerVideo {
  const PlayerVideo({
    required this.id,
    required this.playerId,
    required this.videoUrl,
    required this.titulo,
  });

  final String id;
  final String playerId;
  final String videoUrl;
  final String titulo;

  factory PlayerVideo.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return PlayerVideo(
      id: doc.id,
      playerId: data['playerId'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      titulo: data['titulo'] ?? 'Video de desempenho',
    );
  }
}
