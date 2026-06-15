import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../perfil/perfil_jogador_screen.dart';

class FeedOlheiroScreen extends StatefulWidget {
  const FeedOlheiroScreen({super.key});

  @override
  State<FeedOlheiroScreen> createState() => _FeedOlheiroScreenState();
}

class _FeedOlheiroScreenState extends State<FeedOlheiroScreen> {
  final TextEditingController _buscaController = TextEditingController();

  String _filtroAtivo = 'Todos';
  final List<String> _filtros = [
    'Todos',
    'Meio-Campo',
    'Atacante',
    'Zagueiro',
    'Goleiro',
  ];

  Stream<QuerySnapshot<Map<String, dynamic>>> get _publicacoesStream {
    return FirebaseFirestore.instance
        .collection('publicacoes')
        .orderBy('dataPublicacao', descending: true)
        .snapshots();
  }

  @override
  void initState() {
    super.initState();
    _buscaController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  bool _passaNosFiltros(Map<String, dynamic> publicacao) {
    final busca = _buscaController.text.trim().toLowerCase();
    final nome = (publicacao['nome'] ?? '').toString().toLowerCase();
    final cidade = (publicacao['cidade'] ?? '').toString().toLowerCase();
    final clube = (publicacao['clube'] ?? '').toString().toLowerCase();
    final conteudo = (publicacao['conteudo'] ?? '').toString().toLowerCase();
    final posicao = (publicacao['posicao'] ?? '').toString();

    final correspondeBusca =
        busca.isEmpty ||
        nome.contains(busca) ||
        cidade.contains(busca) ||
        clube.contains(busca) ||
        conteudo.contains(busca);
    final correspondeFiltro =
        _filtroAtivo == 'Todos' || posicao.contains(_filtroAtivo);

    return correspondeBusca && correspondeFiltro;
  }

  String _tempoDaPublicacao(dynamic valor) {
    if (valor is! Timestamp) return 'agora';

    final diferenca = DateTime.now().difference(valor.toDate());
    if (diferenca.inMinutes < 1) return 'agora';
    if (diferenca.inMinutes < 60) return '${diferenca.inMinutes} min';
    if (diferenca.inHours < 24) return '${diferenca.inHours} h';
    return '${diferenca.inDays} d';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: _filtros.map((filtro) {
                  final isSelected = _filtroAtivo == filtro;
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
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _publicacoesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Não foi possível carregar o feed.'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final publicacoes = snapshot.data?.docs
                        .map((documento) => documento.data())
                        .where(_passaNosFiltros)
                        .toList() ??
                    [];

                if (publicacoes.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Nenhuma publicação ainda. Quando um jogador publicar, aparece aqui na hora.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: publicacoes.length,
                  itemBuilder: (context, index) {
                    return _buildPublicationCard(publicacoes[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicationCard(Map<String, dynamic> publicacao) {
    final nome = (publicacao['nome'] ?? 'Jogador').toString();
    final posicao = (publicacao['posicao'] ?? 'Atleta').toString();
    final cidade = (publicacao['cidade'] ?? 'Cidade não informada').toString();
    final idade = (publicacao['idade'] ?? '').toString();
    final conteudo = (publicacao['conteudo'] ?? '').toString();
    final fotoUrl = (publicacao['fotoUrl'] ?? '').toString();
    final tempo = _tempoDaPublicacao(publicacao['dataPublicacao']);

    return GestureDetector(
      onTap: () {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFFE8F8F0),
                  backgroundImage: fotoUrl.isNotEmpty
                      ? NetworkImage(fotoUrl)
                      : null,
                  child: fotoUrl.isEmpty
                      ? const Icon(Icons.person, color: Color(0xFF00B167))
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nome,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$posicao${idade.isNotEmpty ? ' • $idade anos' : ''}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF00B167),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  tempo,
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
            if (conteudo.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                conteudo,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1A1A1A),
                  height: 1.35,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.black45,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    cidade,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
                const Icon(
                  Icons.flash_on,
                  size: 16,
                  color: Color(0xFFFFB800),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Publicado agora',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
