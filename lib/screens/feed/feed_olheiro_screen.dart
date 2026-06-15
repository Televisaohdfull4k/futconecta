import 'package:flutter/material.dart';
import '../perfil/perfil_jogador_screen.dart'; // Importante para o olheiro poder clicar e ver o perfil completo!

class FeedOlheiroScreen extends StatefulWidget {
  const FeedOlheiroScreen({super.key});

  @override
  State<FeedOlheiroScreen> createState() => _FeedOlheiroScreenState();
}

class _FeedOlheiroScreenState extends State<FeedOlheiroScreen> {
  final TextEditingController _buscaController = TextEditingController();

  // Controle de qual filtro está selecionado no momento
  String _filtroAtivo = 'Todos';
  final List<String> _filtros = [
    'Todos',
    'Meio-Campo',
    'Atacante',
    'Zagueiro',
    'Goleiro',
  ];

  // SIMULAÇÃO DO FIREBASE: Lista de jogadores que aparecerão no Feed
  final List<Map<String, dynamic>> _jogadoresMock = [
    {
      'id': '1',
      'nome': 'Rian Oliveira',
      'posicao': 'Meio-Campo Ofensivo',
      'idade': 18,
      'cidade': 'Feira de Santana - BA',
      'fotoUrl':
          'https://images.unsplash.com/photo-1511886929837-354d827aae26?q=80&w=500',
      'nota': 9.4,
      'isVerificado': true,
    },
    {
      'id': '2',
      'nome': 'Lucas Mendes',
      'posicao': 'Atacante',
      'idade': 19,
      'cidade': 'Salvador - BA',
      'fotoUrl':
          'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?q=80&w=500',
      'nota': 8.7,
      'isVerificado': false,
    },
    {
      'id': '3',
      'nome': 'Pedro Santos',
      'posicao': 'Zagueiro',
      'idade': 21,
      'cidade': 'Feira de Santana - BA',
      'fotoUrl':
          'https://images.unsplash.com/photo-1526232761682-d26e03ac148e?q=80&w=500',
      'nota': 8.9,
      'isVerificado': true,
    },
    {
      'id': '4',
      'nome': 'Gabriel Costa',
      'posicao': 'Meio-Campo',
      'idade': 17,
      'cidade': 'São Paulo - SP',
      'fotoUrl':
          'https://images.unsplash.com/photo-1600250395372-22ed9bbf0e75?q=80&w=500',
      'nota': 8.2,
      'isVerificado': false,
    },
  ];

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // AppBar customizada para o Feed
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Descobrir Talentos',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // --- BARRA DE PESQUISA ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: TextField(
              controller: _buscaController,
              decoration: InputDecoration(
                hintText: 'Buscar por nome, cidade ou clube...',
                hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF00B167)),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8F0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.tune,
                    color: Color(0xFF00B167),
                    size: 20,
                  ),
                ),
                filled: true,
                fillColor: const Color(0xFFF5F6F8),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // --- FILTROS RÁPIDOS (Pílulas horizontais) ---
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: _filtros.map((filtro) {
                  bool isSelected = _filtroAtivo == filtro;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => _filtroAtivo = filtro),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF00B167)
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF00B167)
                                : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          filtro,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black54,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // --- LISTA DE JOGADORES (Feed) ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _jogadoresMock.length,
              itemBuilder: (context, index) {
                final jogador = _jogadoresMock[index];
                return _buildPlayerCard(jogador);
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET DO CARD DO JOGADOR ---
  Widget _buildPlayerCard(Map<String, dynamic> jogador) {
    return GestureDetector(
      onTap: () {
        // Ao clicar no card, o olheiro é levado para a tela de Perfil do Jogador!
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PerfilJogadorScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Foto circular
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(jogador['fotoUrl']),
                ),
                if (jogador['isVerificado'])
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified,
                      color: Color(0xFF00B167),
                      size: 20,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Informações do jogador
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jogador['nome'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    jogador['posicao'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF00B167),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.black45,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        jogador['cidade'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.cake_outlined,
                        size: 14,
                        color: Colors.black45,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${jogador['idade']} anos',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Nota (Rating)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6), // Fundo amarelado
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.star, color: Color(0xFFFFB800), size: 20),
                  const SizedBox(height: 4),
                  Text(
                    jogador['nota'].toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
