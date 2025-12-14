import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserToArtist extends StatefulWidget {
  const UserToArtist({super.key});

  @override
  State<UserToArtist> createState() => _UserToArtistState();
}

class _UserToArtistState extends State<UserToArtist> {
  final TextEditingController messageController = TextEditingController();
  int? userId;
  bool loading = true;
  Map<String, dynamic> chatData = {};
  List messages = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Ambil data artist dari argument
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    userId = data['userId'];

    loadMessages(); // panggil API hanya sekali
  }

  Future<void> loadMessages() async {
    chatData = await getMessageUser(userId!);

    setState(() {
      messages = chatData['messages'] ?? [];
      loading = false;
    });
  }

  Future<Map<String, dynamic>> getMessageUser(int userId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    final url = Uri.parse("http://192.168.1.6:8000/api/chat-user/$userId");

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("CHAT DETAIL STATUS: ${response.statusCode}");
    print("CHAT DETAIL BODY: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil chat');
    }
  }

  Future<void> sendMessageArtist(int userId, String message) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    final url = Uri.parse("http://192.168.1.6:8000/api/chat-user/$userId");

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"message": message}),
    );

    print("SEND STATUS: ${response.statusCode}");
    print("SEND BODY: ${response.body}");

    if (response.statusCode == 201) {
      messageController.clear();
      await loadMessages(); // refresh chat
    } else {
      throw Exception('Gagal kirim pesan');
    }
  }

  Widget chatBubble(Map<String, dynamic> msg) {
    final bool isMe = msg['sender_type'] == 'make_up_artist';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? Colors.grey[200] // kita (kiri)
              : Color.fromRGBO(228, 207, 206, 1), // lawan (kanan)
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomLeft: Radius.circular(isMe ? 0 : 14),
            bottomRight: Radius.circular(isMe ? 14 : 0),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Text(msg['message'], style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              _formatTime(msg['created_at']),
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(228, 207, 206, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/logofullnyah.png'),
            ),
            const SizedBox(width: 10),
            const Text(
              'Chat',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            /// CHAT LIST
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  reverse: false,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return chatBubble(messages[index]);
                  },
                ),
              ),
            ),

            /// INPUT CHAT
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Masukkan pesan',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color.fromRGBO(228, 207, 206, 1),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.black87),
                      onPressed: () {
                        if (messageController.text.trim().isNotEmpty) {
                          sendMessageArtist(
                            userId!,
                            messageController.text.trim(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
