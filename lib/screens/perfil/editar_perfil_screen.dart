import 'package:flutter/material.dart';
import 'perfil_jogador_screen.dart'; // Import da tela final do perfil

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  // Controladores para capturar o texto digitado
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _alturaController = TextEditingController();
  final _pesoController = TextEditingController();
  final _partidasController = TextEditingController();
  final _golsController = TextEditingController();
  final _assistenciasController = TextEditingController();

  // Variáveis para os Dropdowns (Menus de seleção)
  String? _posicaoSelecionada = 'Meio-Campo Ofensivo';
  String? _peDominante = 'Direito';

  final List<String> _posicoes = [
    'Goleiro',
    'Zagueiro',
    'Lateral Direito',
    'Lateral Esquerdo',
    'Volante',
    'Meio-Campo Ofensivo',
    'Ponta Direita',
    'Ponta Esquerda',
    'Centroavante',
  ];

  final List<String> _pes = ['Direito', 'Esquerdo', 'Ambidestro'];

  void _salvarPerfil() {
    // Aqui no futuro enviaremos os dados para o Firebase Cloud Firestore!
    print("Nome salvo: ${_nomeController.text}");
    print("Posição salva: $_posicaoSelecionada");

    // Após salvar, leva o usuário para ver como o perfil dele ficou
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PerfilJogadorScreen()),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _alturaController.dispose();
    _pesoController.dispose();
    _partidasController.dispose();
    _golsController.dispose();
    _assistenciasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Fundo bem claro
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Editar Perfil',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _salvarPerfil,
            child: const Text(
              'Salvar',
              style: TextStyle(
                color: Color(0xFF00B167),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- FOTO DE PERFIL COM ÍCONE DE CÂMERA ---
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE8F8F0),
                        width: 4,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1511886929837-354d827aae26?q=80&w=500',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF00B167),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- INFORMAÇÕES PESSOAIS ---
            _buildSectionTitle('INFORMAÇÕES PESSOAIS'),
            _buildInputLabel('Nome Completo'),
            _buildTextField(
              controller: _nomeController,
              hint: 'Ex: Rian Oliveira',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildInputLabel('Idade'),
            _buildTextField(
              controller: _idadeController,
              hint: 'Ex: 18 anos',
              icon: Icons.calendar_today,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),

            // --- DADOS FÍSICOS ---
            _buildSectionTitle('DADOS FÍSICOS'),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputLabel('Altura (m)'),
                      _buildTextField(
                        controller: _alturaController,
                        hint: '1.78',
                        icon: Icons.height,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputLabel('Peso (kg)'),
                      _buildTextField(
                        controller: _pesoController,
                        hint: '72',
                        icon: Icons.monitor_weight_outlined,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- CARACTERÍSTICAS DE JOGO ---
            _buildSectionTitle('CARACTERÍSTICAS DE JOGO'),
            _buildInputLabel('Posição Principal'),
            _buildDropdown(
              value: _posicaoSelecionada,
              items: _posicoes,
              onChanged: (val) => setState(() => _posicaoSelecionada = val),
            ),
            const SizedBox(height: 16),
            _buildInputLabel('Pé Dominante'),
            _buildDropdown(
              value: _peDominante,
              items: _pes,
              onChanged: (val) => setState(() => _peDominante = val),
            ),
            const SizedBox(height: 32),

            // --- ESTATÍSTICAS DA TEMPORADA ---
            _buildSectionTitle('ESTATÍSTICAS DA TEMPORADA'),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInputLabel('Partidas'),
                            _buildTextField(
                              controller: _partidasController,
                              hint: '34',
                              icon: Icons.sports_soccer,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInputLabel('Gols'),
                            _buildTextField(
                              controller: _golsController,
                              hint: '12',
                              icon: Icons.sports_score,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputLabel('Assistências'),
                      _buildTextField(
                        controller: _assistenciasController,
                        hint: '15',
                        icon: Icons.handshake_outlined,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF00B167),
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black54, size: 20),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00B167), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.black87)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
