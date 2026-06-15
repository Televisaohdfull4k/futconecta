import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/player.dart';
import '../../repositories/player_repository.dart';
import '../../services/storage_service.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/section_title.dart';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key, this.playerId});

  final String? playerId;

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _repository = PlayerRepository();
  final _storage = StorageService();
  final _picker = ImagePicker();

  final _nome = TextEditingController();
  final _idade = TextEditingController();
  final _cidade = TextEditingController();
  final _estado = TextEditingController();
  final _telefone = TextEditingController();
  final _altura = TextEditingController();
  final _peso = TextEditingController();
  final _clubeAtual = TextEditingController();
  final _bio = TextEditingController();
  final _jogos = TextEditingController();
  final _gols = TextEditingController();
  final _assistencias = TextEditingController();
  final _amarelos = TextEditingController();
  final _vermelhos = TextEditingController();

<<<<<<< HEAD
  String? _posicaoPrincipal;
  String? _posicaoSecundaria;
  String? _peDominante;
  String _fotoUrl = '';
  File? _foto;
  bool _loaded = false;
  bool _saving = false;
=======
  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) return;

    final documento = await FirebaseFirestore.instance
        .collection('jogadores')
        .doc(usuario.uid)
        .get();
    final perfil = documento.data();
    if (perfil == null || !mounted) return;

    setState(() {
      _nomeController.text = _valor(perfil['nome']);
      _idadeController.text = _valor(perfil['idade']);
      _cidadeController.text = _valor(perfil['cidade']);
      _telefoneController.text = _valor(perfil['telefone']);
      _emailController.text = _valor(perfil['email']);
      _biografiaController.text = _valor(perfil['biografia']);
      _alturaController.text = _valor(perfil['altura']);
      _pesoController.text = _valor(perfil['peso']);
      _clubeAtualController.text = _valor(perfil['clubeAtual']);
      _experienciaController.text = _valor(perfil['experiencia']);
      _partidasController.text = _valor(perfil['partidas']);
      _golsController.text = _valor(perfil['gols']);
      _assistenciasController.text = _valor(perfil['assistencias']);
      _posicaoSelecionada = _opcaoValida(_posicoes, perfil['posicao']);
      _posicaoSecundariaSelecionada = _opcaoValida(
        _posicoes,
        perfil['posicaoSecundaria'],
      );
      _peDominanteSelecionado = _opcaoValida(
        _pesDominantes,
        perfil['peDominante'],
      );
    });
  }

  String _valor(dynamic valor) => (valor ?? '').toString();

  String? _opcaoValida(List<String> opcoes, dynamic valor) {
    final texto = _valor(valor);
    return opcoes.contains(texto) ? texto : null;
  }

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
>>>>>>> 86bafc2ad73c7fca6b4ac07ce7c58fcbfa02ed49

  static const _posicoes = [
    'Goleiro',
    'Zagueiro',
    'Lateral',
    'Volante',
    'Meio-Campo',
    'Atacante',
  ];
  static const _pes = ['Direito', 'Esquerdo', 'Ambos'];

<<<<<<< HEAD
  String get _playerId =>
      widget.playerId ?? FirebaseAuth.instance.currentUser!.uid;

  Future<void> _load() async {
    if (_loaded) return;
    final player = await _repository.getPlayer(_playerId);
    if (player == null) {
      _loaded = true;
      return;
    }
    _nome.text = player.nome;
    _idade.text = player.idade == 0 ? '' : '${player.idade}';
    _cidade.text = player.cidade;
    _estado.text = player.estado;
    _telefone.text = player.telefone;
    _altura.text = player.altura == 0 ? '' : '${player.altura}';
    _peso.text = player.peso == 0 ? '' : '${player.peso}';
    _clubeAtual.text = player.clubeAtual;
    _bio.text = player.biografia;
    _jogos.text = '${player.stats.jogos}';
    _gols.text = '${player.stats.gols}';
    _assistencias.text = '${player.stats.assistencias}';
    _amarelos.text = '${player.stats.cartoesAmarelos}';
    _vermelhos.text = '${player.stats.cartoesVermelhos}';
    _posicaoPrincipal = player.posicaoPrincipal.isEmpty
        ? null
        : player.posicaoPrincipal;
    _posicaoSecundaria = player.posicaoSecundaria.isEmpty
        ? null
        : player.posicaoSecundaria;
    _peDominante = player.peDominante.isEmpty ? null : player.peDominante;
    _fotoUrl = player.fotoUrl;
    _loaded = true;
=======
  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _cidadeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _biografiaController.dispose();
    _alturaController.dispose();
    _pesoController.dispose();
    _clubeAtualController.dispose();
    _experienciaController.dispose();
    _partidasController.dispose();
    _golsController.dispose();
    _assistenciasController.dispose();
    super.dispose();
  }

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
>>>>>>> 86bafc2ad73c7fca6b4ac07ce7c58fcbfa02ed49
  }

  Future<void> _pickPhoto() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _foto = File(image.path));
  }

  Future<void> _pickVideo() async {
    final video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video == null) return;
    final url = await _storage.uploadPlayerVideo(_playerId, File(video.path));
    await _repository.addVideo(
      playerId: _playerId,
      videoUrl: url,
      titulo: 'Video de desempenho',
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video enviado com sucesso.')),
      );
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      var photoUrl = _fotoUrl;
      if (_foto != null) {
        photoUrl = await _storage.uploadProfilePhoto(_playerId, _foto!);
      }
      final existing =
          await _repository.getPlayer(_playerId) ?? Player.empty(_playerId);
      final player = Player(
        id: _playerId,
        userId: existing.userId,
        nome: _nome.text.trim(),
        idade: int.tryParse(_idade.text) ?? 0,
        cidade: _cidade.text.trim(),
        estado: _estado.text.trim().toUpperCase(),
        altura: double.tryParse(_altura.text.replaceAll(',', '.')) ?? 0,
        peso: double.tryParse(_peso.text.replaceAll(',', '.')) ?? 0,
        posicaoPrincipal: _posicaoPrincipal ?? '',
        posicaoSecundaria: _posicaoSecundaria ?? '',
        peDominante: _peDominante ?? '',
        clubeAtual: _clubeAtual.text.trim(),
        biografia: _bio.text.trim(),
        fotoUrl: photoUrl,
        telefone: _telefone.text.trim(),
        stats: PlayerStats(
          jogos: int.tryParse(_jogos.text) ?? 0,
          gols: int.tryParse(_gols.text) ?? 0,
          assistencias: int.tryParse(_assistencias.text) ?? 0,
          cartoesAmarelos: int.tryParse(_amarelos.text) ?? 0,
          cartoesVermelhos: int.tryParse(_vermelhos.text) ?? 0,
        ),
        mediaAvaliacoes: existing.mediaAvaliacoes,
        totalAvaliacoes: existing.totalAvaliacoes,
      );
      await _repository.savePlayer(player);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _nome,
      _idade,
      _cidade,
      _estado,
      _telefone,
      _altura,
      _peso,
      _clubeAtual,
      _bio,
      _jogos,
      _gols,
      _assistencias,
      _amarelos,
      _vermelhos,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _load(),
      builder: (context, snapshot) {
        if (!_loaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Editar perfil')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: InkWell(
                  onTap: _pickPhoto,
                  child: CircleAvatar(
                    radius: 54,
                    backgroundImage: _foto != null
                        ? FileImage(_foto!)
                        : (_fotoUrl.isEmpty ? null : NetworkImage(_fotoUrl))
                              as ImageProvider?,
                    child: _foto == null && _fotoUrl.isEmpty
                        ? const Icon(Icons.add_a_photo, size: 34)
                        : null,
                  ),
                ),
              ),
              const SectionTitle('Informacoes basicas'),
              AppTextField(
                controller: _nome,
                label: 'Nome',
                icon: Icons.person,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(controller: _idade, label: 'Idade'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppTextField(
                      controller: _telefone,
                      label: 'WhatsApp',
                    ),
                  ),
<<<<<<< HEAD
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(controller: _cidade, label: 'Cidade'),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 100,
                    child: AppTextField(controller: _estado, label: 'Estado'),
                  ),
                ],
              ),
              const SectionTitle('Caracteristicas fisicas'),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(controller: _altura, label: 'Altura'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppTextField(controller: _peso, label: 'Peso'),
                  ),
                ],
              ),
              const SectionTitle('Futebol'),
              _dropdown('Posicao principal', _posicaoPrincipal, _posicoes, (v) {
                setState(() => _posicaoPrincipal = v);
              }),
              const SizedBox(height: 10),
              _dropdown('Posicao secundaria', _posicaoSecundaria, _posicoes, (
                v,
              ) {
                setState(() => _posicaoSecundaria = v);
              }),
              const SizedBox(height: 10),
              _dropdown('Pe dominante', _peDominante, _pes, (v) {
                setState(() => _peDominante = v);
              }),
              const SizedBox(height: 10),
              AppTextField(controller: _clubeAtual, label: 'Clube atual'),
              const SectionTitle('Estatisticas'),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(controller: _jogos, label: 'Jogos'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppTextField(controller: _gols, label: 'Gols'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppTextField(
                      controller: _assistencias,
                      label: 'Assist.',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _amarelos,
                      label: 'Amarelos',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppTextField(
                      controller: _vermelhos,
                      label: 'Vermelhos',
                    ),
                  ),
                ],
              ),
              const SectionTitle('Biografia'),
              AppTextField(
                controller: _bio,
                label: 'Apresentacao',
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pickVideo,
                icon: const Icon(Icons.video_library_outlined),
                label: const Text('Adicionar video de desempenho'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
=======
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
>>>>>>> 86bafc2ad73c7fca6b4ac07ce7c58fcbfa02ed49
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Salvar perfil'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dropdown(
    String label,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
