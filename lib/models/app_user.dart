import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { jogador, clubeTreinadorOlheiro }

extension UserTypeX on UserType {
  String get label {
    switch (this) {
      case UserType.jogador:
        return 'Jogador';
      case UserType.clubeTreinadorOlheiro:
        return 'Clube/Treinador/Olheiro';
    }
  }

  String get value {
    switch (this) {
      case UserType.jogador:
        return 'jogador';
      case UserType.clubeTreinadorOlheiro:
        return 'clube_treinador_olheiro';
    }
  }

  static UserType fromValue(String? value) {
    if (value == 'clube' ||
        value == 'olheiro' ||
        value == 'treinador' ||
        value == 'clube_treinador_olheiro') {
      return UserType.clubeTreinadorOlheiro;
    }
    return UserType.jogador;
  }
}

class AppUser {
  const AppUser({
    required this.id,
    required this.tipoUsuario,
    required this.nome,
    required this.email,
    required this.cidade,
    required this.estado,
  });

  final String id;
  final UserType tipoUsuario;
  final String nome;
  final String email;
  final String cidade;
  final String estado;

  factory AppUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return AppUser(
      id: doc.id,
      tipoUsuario: UserTypeX.fromValue(data['tipoUsuario'] ?? data['tipo']),
      nome: data['nome'] ?? '',
      email: data['email'] ?? '',
      cidade: data['cidade'] ?? '',
      estado: data['estado'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipoUsuario': tipoUsuario.value,
      'nome': nome,
      'email': email,
      'cidade': cidade,
      'estado': estado,
    };
  }
}
