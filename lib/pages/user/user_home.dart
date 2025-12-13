import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  Map? user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    user = ModalRoute.of(context)!.settings.arguments as Map?;
  }

  List<Map<String, dynamic>> categories = [
    {"label": "Pesta & Acara", "value": "Pesta"},
    {"label": "Wedding", "value": "Wedding"},
    {"label": "Artistik", "value": "Artistik"},
  ];

  String selectedCategory = "";

  List<dynamic> artistList = [];
  bool isLoading = true;

  Future<List<dynamic>> getIndexUser() async {
    final url = Uri.parse(
      "http://192.168.1.6:8000/api/beranda-user?category=$selectedCategory",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data']['data'];
    } else {
      return [];
    }
  }

  Future<void> loadArtist() async {
    artistList = await getIndexUser();
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
        title: Image.asset('assets/images/logofullnyah.png', height: 50),
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

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/about_us.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Menu Icon Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 20,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: List.generate(categories.length, (index) {
                  final item = categories[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedCategory = item['value'];
                            isLoading = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.deepPurple.shade100,
                        ),
                        child: Image.asset(
                          'assets/images/logofullnyah.png',
                          width: 30,
                          height: 30,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(item['label'], style: TextStyle(fontSize: 12)),
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            // Contoh Card untuk kategori
            isLoading
                ? const CircularProgressIndicator()
                : artistList.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Belum ada data',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: artistList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 kolom
                          mainAxisSpacing: 16, // jarak vertikal
                          crossAxisSpacing: 16, // jarak horizontal
                          childAspectRatio: 0.75, // proporsi tinggi card
                        ),
                    itemBuilder: (context, index) {
                      final artist = artistList[index];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // <- penting
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: Image.network(
                                artist['profile_photo'] ??
                                    "assets/images/user_sign_in.png", // placeholder online
                                width: double.infinity,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    artist['name'] ?? '-',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Kategori: ${artist['category'] ?? '-'}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/deskripsi-artist',
                                          arguments: artist,
                                        );
                                      },
                                      child: const Text("Lihat Profil"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

            const SizedBox(height: 30),
          ],
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
