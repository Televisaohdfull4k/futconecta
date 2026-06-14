import 'package:flutter/material.dart';
import '../perfil/editar_perfil_screen.dart'; // <-- NOVO IMPORT: Tela de Editar Perfil!

// Enum para gerenciar o tipo de conta selecionada
enum TipoUsuario { jogador, clube, olheiro }

class CriarContaScreen extends StatefulWidget {
  const CriarContaScreen({super.key});

  @override
  State<CriarContaScreen> createState() => _CriarContaScreenState();
}

class _CriarContaScreenState extends State<CriarContaScreen> {
  // Estado inicial: Jogador selecionado
  TipoUsuario _tipoSelecionado = TipoUsuario.jogador;

  // Controladores para pegar os dados depois no Firebase
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _repitaSenhaController = TextEditingController();

  // ----------------------------------------------------------------------
  // AQUI ESTÁ A FUNÇÃO ALTERADA!
  // ----------------------------------------------------------------------
  void _realizarCadastro() {
    // Validação básica futura do Firebase pode entrar aqui
    print(
      "Tentando cadastrar: ${_nomeController.text} como ${_tipoSelecionado.name}",
    );

    if (_tipoSelecionado == TipoUsuario.jogador) {
      // Navega para a tela de EDITAR PERFIL logo após criar a conta!
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EditarPerfilScreen()),
      );
    } else if (_tipoSelecionado == TipoUsuario.clube) {
      // Navegar para a tela do Clube (Ainda será desenvolvida)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tela do Clube ainda será desenvolvida!')),
      );
    } else {
      // Navegar para a tela do Olheiro (Ainda será desenvolvida)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tela do Olheiro ainda será desenvolvida!'),
        ),
      );
    }
  }
  // ----------------------------------------------------------------------

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _repitaSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFDF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Criar Conta',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A2F),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Junte-se ao FutConecta e conecte-se ao seu futuro no futebol.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),

              // Campos de Texto
              _buildTextField(
                controller: _nomeController,
                hint: 'Ex: Rian Oliveira',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                hint: 'seu@email.com',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _senhaController,
                hint: 'Mínimo 6 caracteres',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _repitaSenhaController,
                hint: 'Repita sua senha',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 32),

              // Seletor de Tipo de Usuário
              const Text(
                'Eu sou um...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E3A2F),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRoleCard(
                    tipo: TipoUsuario.jogador,
                    icon: Icons.sports_soccer,
                    label: 'Jogador',
                  ),
                  const SizedBox(width: 10),
                  _buildRoleCard(
                    tipo: TipoUsuario.clube,
                    icon: Icons.account_balance,
                    label: 'Clube',
                  ),
                  const SizedBox(width: 10),
                  _buildRoleCard(
                    tipo: TipoUsuario.olheiro,
                    icon: Icons.search,
                    label: 'Olheiro',
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Botão Cadastrar
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _realizarCadastro, // Chama a função que alteramos!
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF388E3C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(
                      fontSize: 16,
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
      ),
    );
  }

  // Widget construtor para os inputs de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
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

  // Widget construtor para os cards selecionáveis (Jogador, Clube, Olheiro)
  Widget _buildRoleCard({
    required TipoUsuario tipo,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _tipoSelecionado == tipo;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _tipoSelecionado = tipo;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF388E3C)
                  : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF388E3C) : Colors.black54,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF388E3C) : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
