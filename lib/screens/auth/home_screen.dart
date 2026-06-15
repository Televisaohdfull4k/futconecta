import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../feed/chat_lista_screen.dart';
import '../feed/feed_olheiro_screen.dart';
import '../favoritos/favoritos_screen.dart';
import '../perfil/perfil_jogador_screen.dart';
import '../ranking/ranking_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indiceAtual = 0;

  final _telas = const [
    FeedOlheiroScreen(),
    RankingScreen(),
    FavoritosScreen(),
    ChatListaScreen(),
    PerfilJogadorScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _indiceAtual, children: _telas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceAtual,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryLight,
        onDestinationSelected: (index) => setState(() => _indiceAtual = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined),
            label: 'Ranking',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: 'Favoritos',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Config',
          ),
        ],
      ),
    );
  }
}
