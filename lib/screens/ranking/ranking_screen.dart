import 'package:flutter/material.dart';

import '../../repositories/player_repository.dart';
import '../../widgets/player_card.dart';
import '../perfil/perfil_jogador_screen.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = PlayerRepository();
    return Scaffold(
      appBar: AppBar(title: const Text('Top 10 jogadores')),
      body: StreamBuilder(
        stream: repository.watchRanking(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final players = snapshot.data!;
          if (players.isEmpty) {
            return const Center(
              child: Text('Ranking sera exibido apos cadastros.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return PlayerCard(
                player: player,
                rank: index + 1,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PerfilJogadorScreen(playerId: player.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
