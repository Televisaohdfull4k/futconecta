import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../auth/home_screen.dart'; // Importando a tela principal

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  // Controladores para todos os campos
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _biografiaController = TextEditingController();
  final _alturaController = TextEditingController();
  final _pesoController = TextEditingController();
  final _clubeAtualController = TextEditingController();
  final _experienciaController = TextEditingController();
  final _partidasController = TextEditingController();
  final _golsController = TextEditingController();
  final _assistenciasController = TextEditingController();
  String? _posicaoSelecionada;
  String? _posicaoSecundariaSelecionada;
  String? _peDominanteSelecionado;

  // Variáveis para a foto de perfil
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _salvarPerfil() async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faça login para salvar o perfil.')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('jogadores').doc(usuario.uid).set({
      'nome': _nomeController.text.trim(),
      'idade': _idadeController.text.trim(),
      'cidade': _cidadeController.text.trim(),
      'telefone': _telefoneController.text.trim(),
      'email': _emailController.text.trim(),
      'biografia': _biografiaController.text.trim(),
      'altura': _alturaController.text.trim(),
      'peso': _pesoController.text.trim(),
      'posicao': _posicaoSelecionada,
      'posicaoSecundaria': _posicaoSecundariaSelecionada,
      'peDominante': _peDominanteSelecionado,
      'clubeAtual': _clubeAtualController.text.trim(),
      'experiencia': _experienciaController.text.trim(),
      'partidas': _partidasController.text.trim(),
      'gols': _golsController.text.trim(),
      'assistencias': _assistenciasController.text.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil atualizado com sucesso!')),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  // Função para abrir a galeria e escolher uma foto
  Future<void> _escolherFoto() async {
    final XFile? fotoSelecionada = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (fotoSelecionada != null) {
      setState(() {
        _imageFile = File(fotoSelecionada.path);
      });
    }
  }

  final List<String> _posicoes = [
    'Goleiro',
    'Zagueiro',
    'Lateral',
    'Volante',
    'Meio-Campo',
    'Atacante',
  ];
  final List<String> _pesDominantes = ['Direito', 'Esquerdo', 'Ambos'];

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1E3A2F),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          prefixIcon: icon != null ? Icon(icon, color: Colors.black54) : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF388E3C), width: 1.5),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Editar Perfil",
          style: TextStyle(
            color: Color(0xFF1E3A2F),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E3A2F)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto de Perfil
            Center(
              child: GestureDetector(
                onTap: _escolherFoto,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color(0xFFE8F5E9),
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : null,
                      child: _imageFile == null
                          ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Color(0xFF388E3C),
                            )
                          : null,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF388E3C),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _buildSectionTitle("INFORMAÇÕES PESSOAIS"),
            _buildTextField(
              "Nome Completo",
              _nomeController,
              icon: Icons.person,
            ),
            _buildTextField(
              "Idade",
              _idadeController,
              icon: Icons.calendar_today,
            ),
            _buildTextField(
              "Cidade e Estado",
              _cidadeController,
              icon: Icons.location_on,
            ),
            _buildTextField(
              "Telefone para contato",
              _telefoneController,
              icon: Icons.phone,
            ),
            _buildTextField("E-mail", _emailController, icon: Icons.email),
            _buildTextField(
              "Biografia / Descrição do atleta",
              _biografiaController,
              icon: Icons.description,
              maxLines: 3,
            ),

            _buildSectionTitle("DADOS FÍSICOS"),
            Row(
              children: [
                Expanded(
                  child: _buildTextField("Altura (m)", _alturaController),
                ),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField("Peso (kg)", _pesoController)),
              ],
            ),

            _buildSectionTitle("CARACTERÍSTICAS DE JOGO"),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Posição Principal",
                labelStyle: TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Color(0xFF388E3C), width: 1.5),
                ),
              ),
              value: _posicaoSelecionada,
              items: _posicoes
                  .map((pos) => DropdownMenuItem(value: pos, child: Text(pos)))
                  .toList(),
              onChanged: (val) => setState(() => _posicaoSelecionada = val),
            ),

            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Posição Secundária",
                labelStyle: TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Color(0xFF388E3C), width: 1.5),
                ),
              ),
              value: _posicaoSecundariaSelecionada,
              items: _posicoes
                  .map((pos) => DropdownMenuItem(value: pos, child: Text(pos)))
                  .toList(),
              onChanged: (val) =>
                  setState(() => _posicaoSecundariaSelecionada = val),
            ),

            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Pé Dominante",
                labelStyle: TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Color(0xFF388E3C), width: 1.5),
                ),
              ),
              value: _peDominanteSelecionado,
              items: _pesDominantes
                  .map((pe) => DropdownMenuItem(value: pe, child: Text(pe)))
                  .toList(),
              onChanged: (val) => setState(() => _peDominanteSelecionado = val),
            ),

            const SizedBox(height: 16),
            _buildTextField(
              "Clube atual",
              _clubeAtualController,
              icon: Icons.shield,
            ),
            _buildTextField(
              "Tempo de experiência",
              _experienciaController,
              icon: Icons.history,
            ),

            _buildSectionTitle("ESTATÍSTICAS DA TEMPORADA"),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    "Partidas",
                    _partidasController,
                    icon: Icons.sports,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                    "Gols",
                    _golsController,
                    icon: Icons.sports_soccer,
                  ),
                ),
              ],
            ),
            _buildTextField(
              "Assistências",
              _assistenciasController,
              icon: Icons.emoji_events,
            ),

            const SizedBox(height: 40),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // Cancelar e voltar
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.redAccent,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _salvarPerfil,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF388E3C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Salvar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
