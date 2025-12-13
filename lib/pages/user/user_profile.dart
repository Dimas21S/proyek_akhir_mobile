import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // Map? user;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   user = ModalRoute.of(context)!.settings.arguments as Map?;
  // }

  Future<Map<String, dynamic>> getProfile() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    // Jika token tidak ditemukan, kembalikan Map kosong
    if (token == null) {
      print("Token tidak ditemukan");
      return {};
    }

    final url = Uri.parse("http://192.168.1.6:8000/api/profile");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    print("Profile Status: ${response.statusCode}");
    print("Profile Body: ${response.body}");

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data'] ?? {};
    } else {
      return {};
    }
  }

  Map<String, dynamic>? profile;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    profile = await getProfile();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logofullnyah.png', height: 40),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text('Home', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/lokasi');
            },
            child: const Text(
              'Location',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/favorit'),
            child: const Text(
              'Favorites',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profil');
            },
            child: const Text('Profile', style: TextStyle(color: Colors.black)),
          ),
          const SizedBox(width: 3),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),

            child: SizedBox(
              width: double.infinity, // Card mengikuti layar
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(20.0),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          const CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage(
                              'assets/images/about_us.png',
                            ),
                          ),

                          const SizedBox(height: 5),

                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFB68D40),
                            ),
                            child: const Text('Edit profile'),
                          ),
                        ],
                      ),

                      //
                      const SizedBox(width: 10),

                      // User info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile?['name'] ?? 'Nama tidak ditemukan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Email row
                            Row(
                              children: [
                                Icon(Icons.email, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  profile?['email'] ?? 'email...',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Password row
                            Row(
                              children: const [
                                Icon(Icons.lock, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  '*************',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            // Row(
                            //   children: [
                            //     ElevatedButton(
                            //       onPressed: () {},
                            //       style: ElevatedButton.styleFrom(
                            //         backgroundColor: Color(0xFFB68D40),
                            //       ),
                            //       child: const Text('Edit profile'),
                            //     ),

                            //     const SizedBox(width: 15),

                            //     ElevatedButton(
                            //       onPressed: () {},
                            //       style: ElevatedButton.styleFrom(
                            //         backgroundColor: Color(0xFFB23B35),
                            //       ),
                            //       child: const Text('Logout'),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Text(
          '© 2025 pakaimua. All rights reserved.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54, fontSize: 12),
        ),
      ),
    );
  }
}
