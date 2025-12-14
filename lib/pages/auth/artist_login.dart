import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArtistLoginPage extends StatefulWidget {
  const ArtistLoginPage({super.key});

  @override
  State<ArtistLoginPage> createState() => _ArtistLoginPageState();
}

class _ArtistLoginPageState extends State<ArtistLoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginArtist() async {
    {
      print('=== LOGIN ATTEMPT ===');
      print('Username: ${usernameController.text}');
      print(
        'Password: ${passwordController.text.isNotEmpty ? '***' : 'empty'}',
      );

      final url = Uri.parse("http://192.168.1.6:8000/api/login-mua");

      final response = await http
          .post(
            url,
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
            },
            body: jsonEncode({
              "username": usernameController.text.trim(),
              "password": passwordController.text.trim(),
            }),
          )
          .timeout(Duration(seconds: 10));

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        // Simpan token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["token"]);
        await prefs.setString("username", data["user"]["username"]);
        await prefs.setString("status", data["user"]["status"]);

        print('Login success! Status: ${data["user"]["status"]}');

        // Navigasi berdasarkan status
        final status = data["user"]["status"];
        if (status == 'accepted') {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/beranda-mua');
        } else {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/submit-request');
        }
      } else if (response.statusCode == 401) {
        // Unauthorized
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "Username atau password salah"),
          ),
        );
      } else if (response.statusCode == 403) {
        // Forbidden (status not accepted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Akun belum diverifikasi")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Login gagal")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Menangani gambar Sign In
                Center(
                  child: Container(
                    width: double.infinity,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/user_sign_in.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Menangani teks Login untuk MUA
                RichText(
                  text: TextSpan(
                    text: 'If you dont have an account, please ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: 'register here',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/register-mua');
                          },
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Menangani Username
                const Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Enter your username',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),

                const SizedBox(height: 20),

                // Menangani Password
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loginArtist,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(64, 56, 121, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const SizedBox(height: 40),

                const Center(
                  child: Text(
                    '© 2025 pakaimua. All rights reserved.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
