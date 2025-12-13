import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserFavorite extends StatefulWidget {
  const UserFavorite({super.key});

  @override
  State<UserFavorite> createState() => _UserFavoriteState();
}

class _UserFavoriteState extends State<UserFavorite> {
  List<dynamic> likedArtists = [];
  bool isLoading = true;

  Future<List<dynamic>> getFavourite() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    // Jika token tidak ditemukan, kembalikan Map kosong
    if (token == null) {
      print("Token tidak ditemukan");
      return [];
    }

    final url = Uri.parse("http://192.168.1.6:8000/api/favorit");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    print("Profile Status: ${response.statusCode}");
    print("Profile Body: ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['liked_artists'];
    } else {
      return [];
    }
  }

  Future<void> loadArtist() async {
    likedArtists = await getFavourite();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadArtist();
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
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
            child: const Text('Home', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/lokasi'),
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
            onPressed: () => Navigator.pushReplacementNamed(context, '/profil'),
            child: const Text('Profile', style: TextStyle(color: Colors.black)),
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(249, 245, 243, 1),
                Color.fromRGBO(255, 255, 255, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Favourite',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: List.generate(likedArtists.length, (index) {
                  final artist = likedArtists[index];

                  return SizedBox(
                    height: 200,
                    width: 200,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: Image.asset(
                                'assets/images/logofullnyah.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  artist['name'] ?? 'Tidak ada nama',
                                  style: const TextStyle(fontSize: 14),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  "Kategori: ${artist['category'] ?? '-'}",
                                  style: const TextStyle(fontSize: 14),
                                ),

                                const SizedBox(height: 10),

                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    child: const Text('Lihat Profil'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
