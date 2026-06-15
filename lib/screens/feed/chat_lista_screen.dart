import 'package:flutter/material.dart';

class ChatListaScreen extends StatelessWidget {
  const ChatListaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulando algumas mensagens no banco de dados
    final List<Map<String, String>> conversas = [
      {
        'nome': 'Olheiro - Flamengo',
        'mensagem': 'Olá Rian, gostamos do seu perfil! Podemos conversar?',
        'tempo': 'Agora',
        'foto':
            'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?q=80&w=150',
      },
      {
        'nome': 'Bahia (Base)',
        'mensagem': 'Você tem disponibilidade para um teste presencial?',
        'tempo': '2h',
        'foto':
            'https://images.unsplash.com/photo-1526232761682-d26e03ac148e?q=80&w=150',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Mensagens',
          style: TextStyle(
            color: Color(0xFF1E3A2F),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: conversas.isEmpty
          ? const Center(child: Text('Nenhuma mensagem ainda.'))
          : ListView.separated(
              itemCount: conversas.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, color: Colors.black12),
              itemBuilder: (context, index) {
                final chat = conversas[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  tileColor: Colors.white,
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(chat['foto']!),
                  ),
                  title: Text(
                    chat['nome']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A2F),
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    chat['mensagem']!,
                    style: const TextStyle(color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    chat['tempo']!,
                    style: const TextStyle(color: Colors.black38, fontSize: 12),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Abrindo conversa com ${chat['nome']}...',
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
