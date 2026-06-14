import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importe o Firebase Core
import 'firebase_options.dart'; // Importe o arquivo gerado
import 'screens/auth/login_screen.dart';

void main() async {
  // Garante que os widgets do Flutter estejam prontos antes de iniciar o Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase com as configurações geradas automaticamente
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const FutConectaApp());
}

class FutConectaApp extends StatelessWidget {
  const FutConectaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FutConecta',
      theme: ThemeData(primaryColor: const Color(0xFF388E3C)),
      home: const LoginScreen(),
    );
  }
}
