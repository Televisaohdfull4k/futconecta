import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerReview {
  const PlayerReview({
    required this.id,
    required this.playerId,
    required this.avaliadorId,
    required this.nota,
    required this.comentario,
    required this.avaliadorNome,
  });

  final String id;
  final String playerId;
  final String avaliadorId;
  final int nota;
  final String comentario;
  final String avaliadorNome;

  factory PlayerReview.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return PlayerReview(
      id: doc.id,
      playerId: data['playerId'] ?? '',
      avaliadorId: data['avaliadorId'] ?? '',
      nota: (data['nota'] as num?)?.toInt() ?? 0,
      comentario: data['comentario'] ?? '',
      avaliadorNome: data['avaliadorNome'] ?? 'Avaliador',
    );
  }
}
