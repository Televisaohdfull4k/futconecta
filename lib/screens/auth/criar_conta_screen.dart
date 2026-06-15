import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_text_field.dart';
import '../perfil/editar_perfil_screen.dart';

class CriarContaScreen extends StatefulWidget {
  const CriarContaScreen({super.key});

  @override
  State<CriarContaScreen> createState() => _CriarContaScreenState();
}

class _CriarContaScreenState extends State<CriarContaScreen> {
  final _authService = AuthService();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  UserType _tipoSelecionado = UserType.jogador;
  bool _isLoading = false;

  Future<void> _criarConta() async {
    final requiredFields = [
      _nomeController.text,
      _emailController.text,
      _senhaController.text,
      _cidadeController.text,
      _estadoController.text,
    ];
    if (requiredFields.any((field) => field.trim().isEmpty)) {
      _showMessage('Preencha todos os campos.');
      return;
    }

    setState(() => _isLoading = true);
    try {
<<<<<<< HEAD
      final user = await _authService.createAccount(
        nome: _nomeController.text,
        email: _emailController.text,
        senha: _senhaController.text,
        cidade: _cidadeController.text,
        estado: _estadoController.text,
        tipoUsuario: _tipoSelecionado,
      );
=======
      // 1. Cria o usuário no Autenticador
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _senhaController.text.trim(),
          );

      // 2. Salva o nome e tipo no Firestore vinculado ao ID do usuário criado
      await FirebaseFirestore.instance
          .collection('jogadores')
          .doc(userCredential.user!.uid)
          .set({
            'nome': _nomeController.text.trim(),
            'email': _emailController.text.trim(),
            'tipo': _tipoSelecionado.toString().split('.').last,
            'idade': '',
            'cidade': '',
            'telefone': '',
            'biografia': '',
            'altura': '',
            'peso': '',
            'posicao': '',
            'posicaoSecundaria': '',
            'peDominante': '',
            'clubeAtual': '',
            'experiencia': '',
            'partidas': '',
            'gols': '',
            'assistencias': '',
            'fotoUrl': '',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

>>>>>>> 86bafc2ad73c7fca6b4ac07ce7c58fcbfa02ed49
      if (!mounted) return;
      if (user.tipoUsuario == UserType.jogador) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => EditarPerfilScreen(playerId: user.id),
          ),
        );
      } else {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      final message = switch (e.code) {
        'email-already-in-use' => 'Este e-mail ja esta cadastrado.',
        'weak-password' => 'A senha precisa ter pelo menos 6 caracteres.',
        _ => 'Nao foi possivel criar sua conta.',
      };
      _showMessage(message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Escolha como voce quer usar o FutConecta.',
            style: TextStyle(fontSize: 16, color: AppColors.muted),
          ),
          const SizedBox(height: 18),
          SegmentedButton<UserType>(
            segments: const [
              ButtonSegment(
                value: UserType.jogador,
                label: Text('Jogador'),
                icon: Icon(Icons.sports_soccer),
              ),
              ButtonSegment(
                value: UserType.clubeTreinadorOlheiro,
                label: Text('Clube/Olheiro'),
                icon: Icon(Icons.manage_search),
              ),
            ],
            selected: {_tipoSelecionado},
            onSelectionChanged: (selection) {
              setState(() => _tipoSelecionado = selection.first);
            },
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _nomeController,
            label: 'Nome',
            icon: Icons.person,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _emailController,
            label: 'E-mail',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _senhaController,
            label: 'Senha',
            icon: Icons.lock_outline,
            obscureText: true,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _cidadeController,
            label: 'Cidade',
            icon: Icons.location_city,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _estadoController,
            label: 'Estado',
            icon: Icons.map_outlined,
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: _isLoading ? null : _criarConta,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Finalizar cadastro'),
          ),
        ],
      ),
    );
  }
}
