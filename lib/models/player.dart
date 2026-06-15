import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerStats {
  const PlayerStats({
    this.jogos = 0,
    this.gols = 0,
    this.assistencias = 0,
    this.cartoesAmarelos = 0,
    this.cartoesVermelhos = 0,
  });

  final int jogos;
  final int gols;
  final int assistencias;
  final int cartoesAmarelos;
  final int cartoesVermelhos;

  factory PlayerStats.fromMap(Map<String, dynamic>? map) {
    final data = map ?? {};
    return PlayerStats(
      jogos: _toInt(data['jogosDisputados'] ?? data['jogos']),
      gols: _toInt(data['gols']),
      assistencias: _toInt(data['assistencias']),
      cartoesAmarelos: _toInt(data['cartoesAmarelos']),
      cartoesVermelhos: _toInt(data['cartoesVermelhos']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jogosDisputados': jogos,
      'gols': gols,
      'assistencias': assistencias,
      'cartoesAmarelos': cartoesAmarelos,
      'cartoesVermelhos': cartoesVermelhos,
    };
  }

  int get score => (jogos * 2) + (gols * 5) + (assistencias * 4);
}

class Player {
  const Player({
    required this.id,
    required this.userId,
    required this.nome,
    required this.idade,
    required this.cidade,
    required this.estado,
    required this.altura,
    required this.peso,
    required this.posicaoPrincipal,
    required this.posicaoSecundaria,
    required this.peDominante,
    required this.clubeAtual,
    required this.biografia,
    required this.fotoUrl,
    required this.stats,
    required this.mediaAvaliacoes,
    required this.totalAvaliacoes,
    this.telefone = '',
  });

  final String id;
  final String userId;
  final String nome;
  final int idade;
  final String cidade;
  final String estado;
  final double altura;
  final double peso;
  final String posicaoPrincipal;
  final String posicaoSecundaria;
  final String peDominante;
  final String clubeAtual;
  final String biografia;
  final String fotoUrl;
  final PlayerStats stats;
  final double mediaAvaliacoes;
  final int totalAvaliacoes;
  final String telefone;

  factory Player.empty(String userId) {
    return Player(
      id: userId,
      userId: userId,
      nome: '',
      idade: 0,
      cidade: '',
      estado: '',
      altura: 0,
      peso: 0,
      posicaoPrincipal: '',
      posicaoSecundaria: '',
      peDominante: '',
      clubeAtual: '',
      biografia: '',
      fotoUrl: '',
      stats: const PlayerStats(),
      mediaAvaliacoes: 0,
      totalAvaliacoes: 0,
    );
  }

  factory Player.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Player(
      id: doc.id,
      userId: data['userId'] ?? doc.id,
      nome: data['nome'] ?? '',
      idade: _toInt(data['idade']),
      cidade: data['cidade'] ?? '',
      estado: data['estado'] ?? '',
      altura: _toDouble(data['altura']),
      peso: _toDouble(data['peso']),
      posicaoPrincipal: data['posicaoPrincipal'] ?? data['posicao'] ?? '',
      posicaoSecundaria: data['posicaoSecundaria'] ?? '',
      peDominante: data['peDominante'] ?? '',
      clubeAtual: data['clubeAtual'] ?? '',
      biografia: data['biografia'] ?? '',
      fotoUrl: data['fotoUrl'] ?? '',
      telefone: data['telefone'] ?? '',
      stats: PlayerStats.fromMap(data['estatisticas']),
      mediaAvaliacoes: _toDouble(data['mediaAvaliacoes']),
      totalAvaliacoes: _toInt(data['totalAvaliacoes']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'nome': nome,
      'idade': idade,
      'cidade': cidade,
      'estado': estado,
      'altura': altura,
      'peso': peso,
      'posicaoPrincipal': posicaoPrincipal,
      'posicaoSecundaria': posicaoSecundaria,
      'peDominante': peDominante,
      'clubeAtual': clubeAtual,
      'biografia': biografia,
      'fotoUrl': fotoUrl,
      'telefone': telefone,
      'estatisticas': stats.toMap(),
      'mediaAvaliacoes': mediaAvaliacoes,
      'totalAvaliacoes': totalAvaliacoes,
      'search':
          '${nome.toLowerCase()} ${cidade.toLowerCase()} '
          '${estado.toLowerCase()} ${posicaoPrincipal.toLowerCase()}',
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  int get rankingScore {
    return (mediaAvaliacoes * 100).round() +
        (totalAvaliacoes * 20) +
        stats.score;
  }
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse((value?.toString() ?? '').replaceAll(',', '.')) ?? 0;
}
