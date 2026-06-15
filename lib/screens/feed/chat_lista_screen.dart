import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../repositories/chat_repository.dart';
import '../chat/chat_screen.dart';

class ChatListaScreen extends StatelessWidget {
  const ChatListaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final repository = ChatRepository();
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Entre para ver mensagens.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mensagens')),
      body: StreamBuilder(
        stream: repository.watchConversations(user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          final seen = <String>{};
          final conversations = docs.where((doc) {
            final data = doc.data();
            final participants = List<String>.from(data['participants'] ?? []);
            final other = participants.firstWhere(
              (id) => id != user.uid,
              orElse: () => '',
            );
            if (other.isEmpty || seen.contains(other)) return false;
            seen.add(other);
            return true;
          }).toList();

          if (conversations.isEmpty) {
            return const Center(child: Text('Nenhuma conversa ainda.'));
          }

          return ListView.separated(
            itemCount: conversations.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final data = conversations[index].data();
              final participants = List<String>.from(
                data['participants'] ?? [],
              );
              final other = participants.firstWhere((id) => id != user.uid);
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text('Conversa com $other'),
                subtitle: Text(
                  data['texto'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ChatScreen(receiverId: other, receiverName: other),
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
