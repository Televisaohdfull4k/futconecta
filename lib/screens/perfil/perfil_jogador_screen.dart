import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import 'editar_perfil_screen.dart';

class PerfilJogadorScreen extends StatelessWidget {
  const PerfilJogadorScreen({super.key});

  DocumentReference<Map<String, dynamic>>? get _perfilRef {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) return null;
    return FirebaseFirestore.instance.collection('jogadores').doc(usuario.uid);
  }

  Future<void> _abrirPublicacao(BuildContext context) async {
    final textoController = TextEditingController();

    final conteudo = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Nova publicação'),
          content: TextField(
            controller: textoController,
            autofocus: true,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Conte sua novidade, treino ou resultado...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, textoController.text.trim());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF388E3C),
              ),
              child: const Text(
                'Publicar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    textoController.dispose();

    if (conteudo == null || conteudo.isEmpty) return;

    final usuario = FirebaseAuth.instance.currentUser;
    final perfilRef = _perfilRef;
    if (usuario == null || perfilRef == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faça login para publicar.')),
      );
      return;
    }

    try {
      final jogadorDoc = await perfilRef.get();
      final jogador = jogadorDoc.data() ?? {};

      await FirebaseFirestore.instance.collection('publicacoes').add({
        'jogadorId': usuario.uid,
        'nome': _texto(jogador['nome'], 'Jogador'),
        'email': usuario.email,
        'posicao': _texto(jogador['posicao'], 'Atleta'),
        'cidade': _texto(jogador['cidade'], 'Cidade não informada'),
        'idade': _texto(jogador['idade'], ''),
        'clube': _texto(jogador['clubeAtual'], ''),
        'fotoUrl': _texto(jogador['fotoUrl'], ''),
        'conteudo': conteudo,
        'dataPublicacao': Timestamp.fromDate(DateTime.now()),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Publicação enviada para o feed!')),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao publicar. Tente novamente.')),
      );
    }
  }

  static String _texto(dynamic valor, String fallback) {
    final texto = (valor ?? '').toString().trim();
    return texto.isEmpty ? fallback : texto;
  }

  @override
  Widget build(BuildContext context) {
    final perfilRef = _perfilRef;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Meu Perfil',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF388E3C)),
            onPressed: () => _abrirPublicacao(context),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF388E3C)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditarPerfilScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: perfilRef == null
          ? const Center(child: Text('Faça login para ver seu perfil.'))
          : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: perfilRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Não foi possível carregar seu perfil.'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final perfil = snapshot.data?.data() ?? {};
                return _PerfilConteudo(
                  perfil: perfil,
                  onPublicar: () => _abrirPublicacao(context),
                );
              },
            ),
    );
  }
}

class _PerfilConteudo extends StatelessWidget {
  const _PerfilConteudo({required this.perfil, required this.onPublicar});

  final Map<String, dynamic> perfil;
  final VoidCallback onPublicar;

  String _texto(String campo, String fallback) {
    final texto = (perfil[campo] ?? '').toString().trim();
    return texto.isEmpty ? fallback : texto;
  }

  @override
  Widget build(BuildContext context) {
    final nome = _texto('nome', 'Jogador');
    final posicao = _texto('posicao', 'Atleta');
    final idade = _texto('idade', '');
    final cidade = _texto('cidade', 'Cidade não informada');
    final altura = _texto('altura', '-');
    final peso = _texto('peso', '-');
    final gols = _texto('gols', '0');
    final partidas = _texto('partidas', '0');
    final assistencias = _texto('assistencias', '0');
    final biografia = _texto(
      'biografia',
      'Complete seu perfil para contar sua história no futebol.',
    );
    final fotoUrl = _texto('fotoUrl', '');

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFFE8F5E9),
                  backgroundImage: fotoUrl.isNotEmpty
                      ? NetworkImage(fotoUrl)
                      : null,
                  child: fotoUrl.isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 60,
                          color: Color(0xFF388E3C),
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  nome,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A2F),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$posicao${idade.isNotEmpty ? ' • $idade anos' : ''}',
                    style: const TextStyle(
                      color: Color(0xFF388E3C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, size: 20, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(cidade, style: const TextStyle(color: Colors.black87)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.height, size: 20, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                      altura == '-' ? altura : '${altura}m',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.monitor_weight_outlined,
                      size: 20,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      peso == '-' ? peso : '$peso kg',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPublicar,
                    icon: const Icon(
                      Icons.add,
                      color: Color(0xFF388E3C),
                      size: 20,
                    ),
                    label: const Text(
                      'Publicar',
                      style: TextStyle(
                        color: Color(0xFF388E3C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF388E3C),
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Iniciando contato...')),
                      );
                    },
                    icon: const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      'Contato',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF388E3C),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sobre o atleta',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A2F),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  biografia,
                  style: const TextStyle(color: Colors.black87, height: 1.4),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Estatísticas da Temporada',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A2F),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatCard('Gols', gols, Icons.sports_soccer),
                    _buildStatCard('Partidas', partidas, Icons.stadium),
                    _buildStatCard('Assists', assistencias, Icons.handshake),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF388E3C), size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A2F),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
