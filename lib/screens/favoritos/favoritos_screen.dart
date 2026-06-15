import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../repositories/favorites_repository.dart';
import '../../repositories/player_repository.dart';
import '../../widgets/player_card.dart';
import '../perfil/perfil_jogador_screen.dart';

class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final favoritesRepository = FavoritesRepository();
    final playerRepository = PlayerRepository();

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Entre para ver favoritos.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Meus favoritos')),
      body: StreamBuilder<Set<String>>(
        stream: favoritesRepository.watchFavoritePlayerIds(userId),
        builder: (context, favSnapshot) {
          final ids = favSnapshot.data ?? <String>{};
          if (ids.isEmpty) {
            return const Center(
              child: Text('Nenhum jogador favoritado ainda.'),
            );
          }
          return StreamBuilder(
            stream: playerRepository.watchPlayers(),
            builder: (context, playerSnapshot) {
              if (!playerSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final players = playerSnapshot.data!
                  .where((player) => ids.contains(player.id))
                  .toList();
              return ListView(
                padding: const EdgeInsets.all(16),
                children: players.map((player) {
                  return PlayerCard(
                    player: player,
                    isFavorite: true,
                    onFavorite: () => favoritesRepository.toggleFavorite(
                      clubId: userId,
                      playerId: player.id,
                      isFavorite: true,
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PerfilJogadorScreen(playerId: player.id),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
