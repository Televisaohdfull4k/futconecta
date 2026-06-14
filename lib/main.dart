import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart'; // Mude o import para chamar a tela de Login

void main() {
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
      // Mude a home para LoginScreen
      home: const LoginScreen(),
    );
  }
}
