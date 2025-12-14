import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Fungsi kirim data ke API Laravel
  Future<void> loginUser() async {
    final url = Uri.parse('http://192.168.1.6:8000/api/login');

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        'name': usernameController.text.trim(),
        'password': passwordController.text.trim(),
      }),
    );

    print('Status Code: ${response.statusCode}'); // Debug
    print('Response Body: ${response.body}');

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      if (!mounted) return;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', data['user']['id']);
      await prefs.setString('token', data['token']);
      final role = data['user']['role'];
      if (role == 'admin') {
        Navigator.pushReplacementNamed(
          context,
          '/admin-home',
          arguments: {
            'id': data['user']['id'],
            'name': data['user']['name'],
            'email': data['user']['email'],
            'role': data['user']['role'],
            'token': data['token'],
          },
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/beranda',
          arguments: {
            'id': data['user']['id'],
            'name': data['user']['name'],
            'email': data['user']['email'],
            'role': data['user']['role'],
            'token': data['token'],
          },
        );
      }

      // Navigasi ke halaman dashboard + kirim data user
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login gagal")));
    }
  }

  @override
  // Nested Columns
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            // Login Form
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
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

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
                            Navigator.pushNamed(context, '/register');
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

                const SizedBox(height: 32),

                // Input Username
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Username",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: usernameController,
                      obscureText: false,
                      decoration: const InputDecoration(
                        hintText: "Enter your username",
                        border: UnderlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Input Password
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Enter your password",
                        border: UnderlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(64, 56, 121, 1),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
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

                const SizedBox(height: 40),

                Center(
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
