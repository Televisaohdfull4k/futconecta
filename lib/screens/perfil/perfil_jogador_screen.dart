import 'package:flutter/material.dart';

class PerfilJogadorScreen extends StatelessWidget {
  const PerfilJogadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(title: const Text('Meu Perfil'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1511886929837-354d827aae26?q=80&w=500',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Rian Oliveira',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Meio-Campo • 18 anos',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _buildTechStat('Precisão de Passe', 0.88, Colors.green),
            _buildTechStat('Dribles', 0.74, Colors.blue),
            _buildTechStat('Chutes ao Alvo', 0.62, Colors.orange),
            const SizedBox(height: 32),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(label: 'Gols', value: '12'),
                _StatItem(label: 'Partidas', value: '34'),
                _StatItem(label: 'Assists', value: '15'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechStat(String label, double val, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        LinearProgressIndicator(
          value: val,
          color: color,
          minHeight: 10,
          backgroundColor: Colors.grey[200],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value;
  const _StatItem({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}
