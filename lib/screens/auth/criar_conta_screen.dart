import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../perfil/editar_perfil_screen.dart';
import '../feed/feed_olheiro_screen.dart';

enum TipoUsuario { jogador, clube, olheiro }

class CriarContaScreen extends StatefulWidget {
  const CriarContaScreen({super.key});
  @override
  State<CriarContaScreen> createState() => _CriarContaScreenState();
}

class _CriarContaScreenState extends State<CriarContaScreen> {
  TipoUsuario _tipoSelecionado = TipoUsuario.jogador;
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _isLoading = false;

  Future<void> _realizarCadastro() async {
    if (_nomeController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );
      if (!mounted) return;

      // Direciona para a tela correta dependendo do tipo
      if (_tipoSelecionado == TipoUsuario.jogador) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EditarPerfilScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FeedOlheiroScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String mensagem = 'Erro ao criar conta';
      if (e.code == 'email-already-in-use') {
        mensagem = 'Este e-mail já está cadastrado.';
      } else if (e.code == 'weak-password') {
        mensagem = 'A senha é muito fraca (mínimo de 6 caracteres).';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensagem)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1E3A2F)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Cabeçalho ---
            const Text(
              'Crie sua Conta',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A2F),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Junte-se ao FutConecta e mostre seu talento para o mundo.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 32),

            // --- Formulário ---
            const Text(
              'Nome Completo',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _nomeController,
              hint: 'Como você quer ser chamado',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 20),

            const Text(
              'E-mail',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _emailController,
              hint: 'seu@email.com',
              icon: Icons.mail_outline,
            ),
            const SizedBox(height: 20),

            const Text(
              'Senha',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _senhaController,
              hint: 'Mínimo de 6 caracteres',
              icon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 32),

            // --- Seletor de Tipo de Conta (Cards Visuais) ---
            const Text(
              'Eu sou um:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildRoleCard(
                  title: 'Jogador',
                  icon: Icons.sports_soccer,
                  type: TipoUsuario.jogador,
                ),
                const SizedBox(width: 16),
                _buildRoleCard(
                  title: 'Olheiro/Clube',
                  icon: Icons.search,
                  type: TipoUsuario.olheiro,
                ),
              ],
            ),
            const SizedBox(height: 40),

            // --- Botão de Cadastro ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _realizarCadastro,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF388E3C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Finalizar Cadastro',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  // Construtor das Caixas de Texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black54),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF388E3C), width: 1.5),
        ),
      ),
    );
  }

  // Construtor dos Cards de Escolha (Jogador vs Olheiro)
  Widget _buildRoleCard({
    required String title,
    required IconData icon,
    required TipoUsuario type,
  }) {
    bool isSelected = _tipoSelecionado == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tipoSelecionado = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF388E3C) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF388E3C)
                  : Colors.grey.shade300,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF388E3C).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 36,
                color: isSelected ? Colors.white : Colors.black54,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
