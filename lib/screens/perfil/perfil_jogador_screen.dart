import 'package:flutter/material.dart';

class PerfilJogadorScreen extends StatelessWidget {
  const PerfilJogadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ------------------------------------------------------------------------
    // SIMULAÇÃO DO FIREBASE: Aqui é onde os dados do jogador vão chegar!
    // Quando conectarmos o banco, vamos apenas substituir esse Map.
    // ------------------------------------------------------------------------
    final Map<String, dynamic> dadosDoJogador = {
      'fotoUrl':
          'https://images.unsplash.com/photo-1511886929837-354d827aae26?q=80&w=500',
      'nome': 'Rian Oliveira',
      'idade': 18,
      'nacionalidade': 'Brasileiro',
      'isVerificado': true,
      'altura': '1.78',
      'peso': '72',
      'posicaoPrincipal': 'Meio-Campo Ofensivo',
      'peDominante': 'Direito',
      'temporada': '2023/24',
      'stats': {'partidas': 34, 'gols': 12, 'assistencias': 15},
      'atributosElite': ['Visão de Jogo', 'Drible Curto', 'Cobrança de Falta'],
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9), // Fundo claro da imagem
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Botões de Navegação (Voltar e Editar)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconBtn(
                    Icons.arrow_back_ios_new,
                    () => Navigator.pop(context),
                  ),
                  _buildIconBtn(Icons.edit_note, () {
                    // Futura tela de edição
                  }),
                ],
              ),
              const SizedBox(height: 20),

              // 2. Foto de Perfil + Selo de Verificado
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4), // Borda verde clara
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE0F2E9),
                        width: 4,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 65,
                      backgroundImage: NetworkImage(dadosDoJogador['fotoUrl']),
                    ),
                  ),
                  if (dadosDoJogador['isVerificado'])
                    Transform.translate(
                      offset: const Offset(
                        30,
                        -10,
                      ), // Desloca o selo para o lado
                      child: const Icon(
                        Icons.verified,
                        color: Color(0xFF00B167),
                        size: 32,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // 3. Nome e Informações Básicas
              Text(
                dadosDoJogador['nome'],
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${dadosDoJogador['idade']} anos • ${dadosDoJogador['nacionalidade']}',
                style: TextStyle(fontSize: 15, color: Colors.blueGrey.shade600),
              ),
              const SizedBox(height: 32),

              // 4. Características Físicas (Altura e Peso)
              Row(
                children: [
                  Expanded(
                    child: _buildPhysicalCard(
                      icon: Icons.height,
                      title: 'Altura',
                      value: '${dadosDoJogador['altura']} m',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildPhysicalCard(
                      icon: Icons.monitor_weight_outlined,
                      title: 'Peso',
                      value: '${dadosDoJogador['peso']} kg',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 5. Posição Principal e Dominância (Card Escuro)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E), // Preto do card
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'POSIÇÃO PRINCIPAL',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dadosDoJogador['posicaoPrincipal'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'DOMINÂNCIA',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.sports_soccer,
                              color: Color(0xFF00B167),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dadosDoJogador['peDominante'],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 6. Temporada / Estatísticas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Temporada ${dadosDoJogador['temporada']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F8F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Ver Detalhes',
                      style: TextStyle(
                        color: Color(0xFF00B167),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Blocos Coloridos de Estatísticas (Adaptados para ter conteúdo real)
              Row(
                children: [
                  Expanded(
                    child: _buildStatBlock(
                      color: const Color(0xFF2ECC71),
                      label: 'Partidas',
                      value: dadosDoJogador['stats']['partidas'].toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatBlock(
                      color: const Color(0xFF27AE60),
                      label: 'Gols',
                      value: dadosDoJogador['stats']['gols'].toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatBlock(
                      color: const Color(0xFF3498DB),
                      label: 'Assist.',
                      value: dadosDoJogador['stats']['assistencias'].toString(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 7. Atributos de Elite
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Atributos de Elite',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Lista dinâmica de atributos
                    ...List.generate(
                      dadosDoJogador['atributosElite'].length,
                      (index) => _buildAtributoPill(
                        dadosDoJogador['atributosElite'][index],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS CONSTRUTORES AUXILIARES ---

  Widget _buildIconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black87, size: 22),
      ),
    );
  }

  Widget _buildPhysicalCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F8F0),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF00B167), size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blueGrey.shade400,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Bloco colorido de estatísticas (Aprimorei a imagem da IA adicionando os números dentro)
  Widget _buildStatBlock({
    required Color color,
    required String label,
    required String value,
  }) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Pílulas verde-claras da lista de atributos de elite
  Widget _buildAtributoPill(String atributo) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          atributo,
          style: const TextStyle(
            color: Color(0xFF00B167),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
