import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/player.dart';
import '../../repositories/favorites_repository.dart';
import '../../repositories/player_repository.dart';
import '../../theme/app_theme.dart';
import '../../widgets/player_card.dart';
import '../perfil/perfil_jogador_screen.dart';
import '../search/busca_jogadores_screen.dart';

class FeedOlheiroScreen extends StatelessWidget {
  const FeedOlheiroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerRepository = PlayerRepository();
    final favoritesRepository = FavoritesRepository();
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Descobrir talentos'),
        actions: [
          IconButton(
            tooltip: 'Busca avancada',
            icon: const Icon(Icons.tune),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BuscaJogadoresScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Player>>(
        stream: playerRepository.watchPlayers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final players = snapshot.data!;
          return StreamBuilder<Set<String>>(
            stream: currentUserId == null
                ? Stream.value(<String>{})
                : favoritesRepository.watchFavoritePlayerIds(currentUserId),
            builder: (context, favoritesSnapshot) {
              final favorites = favoritesSnapshot.data ?? <String>{};
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _FeaturedPlayer(repository: playerRepository),
                  const SizedBox(height: 12),
                  TextField(
                    readOnly: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BuscaJogadoresScreen(),
                        ),
                      );
                    },
                    decoration: const InputDecoration(
                      hintText: 'Pesquisar por posicao, cidade, idade...',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: Icon(Icons.manage_search),
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (players.isEmpty)
                    const _EmptyState()
                  else
                    ...players.map((player) {
                      final isFavorite = favorites.contains(player.id);
                      return PlayerCard(
                        player: player,
                        isFavorite: isFavorite,
                        onFavorite: currentUserId == null
                            ? null
                            : () => favoritesRepository.toggleFavorite(
                                clubId: currentUserId,
                                playerId: player.id,
                                isFavorite: isFavorite,
                              ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PerfilJogadorScreen(playerId: player.id),
                          ),
                        ),
                      );
                    }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _FeaturedPlayer extends StatelessWidget {
  const _FeaturedPlayer({required this.repository});

  final PlayerRepository repository;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Player?>(
      stream: repository.watchFeaturedPlayer(),
      builder: (context, snapshot) {
        final player = snapshot.data;
        if (player == null) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundImage: player.fotoUrl.isEmpty
                    ? null
                    : NetworkImage(player.fotoUrl),
                backgroundColor: Colors.white,
                child: player.fotoUrl.isEmpty
                    ? const Icon(Icons.person, color: AppColors.primary)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jogador em destaque da semana',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      player.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '${player.mediaAvaliacoes.toStringAsFixed(1)} estrelas • ${player.stats.gols} gols',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Ver perfil',
                color: Colors.white,
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PerfilJogadorScreen(playerId: player.id),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Icon(Icons.sports_soccer, size: 48, color: AppColors.muted),
          SizedBox(height: 12),
          Text('Nenhum jogador cadastrado ainda.'),
        ],
      ),
    );
  }
}
