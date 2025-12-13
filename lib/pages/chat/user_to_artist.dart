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
    userId = data['id'];

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
    final url = Uri.parse("http://192.168.1.6:8000/api/chat-mua/$userId");

    final response = await http.post(url);

    if (response.statusCode == 201) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      return {};
    }
  }

  Future<void> sendMessageArtist(int userId, String message) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    if (token == null) {
      print("Token tidak ditemukan");
      return;
    }

    final url = Uri.parse("http://192.168.1.6:8000/api/chat-mua/$userId");

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"message": message}),
    );

    if (response.statusCode == 201) {
      print("Berhasil kirim chat: ${response.body}");
    } else {
      print("Gagal: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 120,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),

            const SizedBox(width: 10),

            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/logofullnyah.png'),
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(228, 207, 206, 1),
        elevation: 0,
      ),

      body: SafeArea(child: Container(padding: EdgeInsets.all(16))),

      bottomNavigationBar: SizedBox(
        width: 100,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              obscureText: false,
              decoration: InputDecoration(
                hintText: 'Masukkan pesan',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.place),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
