import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/player.dart';
import '../../repositories/favorites_repository.dart';
import '../../repositories/player_repository.dart';
import '../../widgets/player_card.dart';
import '../perfil/perfil_jogador_screen.dart';

class BuscaJogadoresScreen extends StatefulWidget {
  const BuscaJogadoresScreen({super.key});

  @override
  State<BuscaJogadoresScreen> createState() => _BuscaJogadoresScreenState();
}

class _BuscaJogadoresScreenState extends State<BuscaJogadoresScreen> {
  final _repository = PlayerRepository();
  final _favoritesRepository = FavoritesRepository();
  final _queryController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _idadeMinController = TextEditingController();
  final _idadeMaxController = TextEditingController();
  final _alturaController = TextEditingController();
  String? _posicao;
  String? _peDominante;

  static const _posicoes = [
    'Goleiro',
    'Zagueiro',
    'Lateral',
    'Volante',
    'Meio-Campo',
    'Atacante',
  ];
  static const _pes = ['Direito', 'Esquerdo', 'Ambos'];

  PlayerFilters get _filters => PlayerFilters(
    query: _queryController.text,
    posicao: _posicao,
    idadeMin: int.tryParse(_idadeMinController.text),
    idadeMax: int.tryParse(_idadeMaxController.text),
    cidade: _cidadeController.text.trim().isEmpty
        ? null
        : _cidadeController.text.trim(),
    estado: _estadoController.text.trim().isEmpty
        ? null
        : _estadoController.text.trim().toUpperCase(),
    alturaMin: double.tryParse(_alturaController.text.replaceAll(',', '.')),
    peDominante: _peDominante,
  );

  @override
  void dispose() {
    _queryController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _idadeMinController.dispose();
    _idadeMaxController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('Busca de jogadores')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _queryController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Nome, cidade, clube ou posicao',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _DropFilter(
                label: 'Posicao',
                value: _posicao,
                values: _posicoes,
                onChanged: (value) => setState(() => _posicao = value),
              ),
              _DropFilter(
                label: 'Pe dominante',
                value: _peDominante,
                values: _pes,
                onChanged: (value) => setState(() => _peDominante = value),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _smallField(_idadeMinController, 'Idade min')),
              const SizedBox(width: 8),
              Expanded(child: _smallField(_idadeMaxController, 'Idade max')),
              const SizedBox(width: 8),
              Expanded(child: _smallField(_alturaController, 'Altura min')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _smallField(_cidadeController, 'Cidade')),
              const SizedBox(width: 8),
              SizedBox(
                width: 96,
                child: _smallField(_estadoController, 'Estado'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          StreamBuilder<List<Player>>(
            stream: _repository.watchPlayers(filters: _filters),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final players = snapshot.data!;
              return StreamBuilder<Set<String>>(
                stream: currentUserId == null
                    ? Stream.value(<String>{})
                    : _favoritesRepository.watchFavoritePlayerIds(
                        currentUserId,
                      ),
                builder: (context, favoritesSnapshot) {
                  final favorites = favoritesSnapshot.data ?? <String>{};
                  if (players.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Center(child: Text('Nenhum jogador encontrado.')),
                    );
                  }
                  return Column(
                    children: players.map((player) {
                      final isFavorite = favorites.contains(player.id);
                      return PlayerCard(
                        player: player,
                        isFavorite: isFavorite,
                        onFavorite: currentUserId == null
                            ? null
                            : () => _favoritesRepository.toggleFavorite(
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
                    }).toList(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _smallField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(labelText: label),
    );
  }
}

class _DropFilter extends StatelessWidget {
  const _DropFilter({
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<String> values;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        items: [
          const DropdownMenuItem<String>(value: null, child: Text('Todos')),
          ...values.map(
            (item) => DropdownMenuItem(value: item, child: Text(item)),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
