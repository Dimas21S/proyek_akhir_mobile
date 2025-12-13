import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserToDescription extends StatefulWidget {
  const UserToDescription({super.key});

  @override
  State<UserToDescription> createState() => _UserToDescriptionState();
}

class _UserToDescriptionState extends State<UserToDescription> {
  Map? artist; // data yang dikirim dari halaman sebelumnya
  bool isLiked = false;
  int? userId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ambil arguments dari Navigator
    artist = ModalRoute.of(context)!.settings.arguments as Map?;
    print(jsonEncode(artist));
  }

  Future<void> toggleLike(int artistId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse("http://192.168.1.6:8000/api/deskripsi-artis/$artistId"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        isLiked = data['liked'];
      });
    } else {
      print("Gagal Like: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        backgroundColor: Color.fromRGBO(228, 207, 206, 1),
        elevation: 0,
        title: Text(
          'Profil Artist',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {
              toggleLike(artist!['id']);
            },
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.black,
              size: 24,
            ),
            tooltip: 'Like',
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/user-to-artist',
                arguments: artist,
              );
            },
            icon: Icon(Icons.chat, color: Colors.black, size: 24),
            tooltip: 'Chat',
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/rating', arguments: artist?['id']);
            },
            icon: Icon(Icons.star, color: Colors.black, size: 24),
            tooltip: 'Rating',
          ),
          IconButton(
            onPressed: () {
              // WhatsApp functionality
              final phone = artist!['phone'];
              if (phone != null) {
                // Implement WhatsApp launch
              }
            },
            icon: Icon(Icons.chat_bubble, color: Colors.green, size: 24),
            tooltip: 'WhatsApp',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PROFILE SECTION
                Container(
                  padding: EdgeInsets.all(20),
                  color: Color.fromRGBO(228, 207, 206, 0.3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PROFILE PHOTO
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: artist!['profile_photo'] != null
                                ? NetworkImage(artist!['profile_photo'])
                                : AssetImage('assets/images/user_sign_in.png')
                                      as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 20),

                      // BIOGRAPHY
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              artist!['username'] ?? 'Nama Artist',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),

                            SizedBox(height: 8),

                            _buildInfoRow(
                              icon: Icons.category,
                              text:
                                  artist!['category'] ?? 'Kategori belum diisi',
                            ),

                            SizedBox(height: 6),

                            _buildInfoRow(
                              icon: Icons.phone,
                              text: artist!['phone'] ?? 'Telepon belum diisi',
                            ),

                            SizedBox(height: 6),

                            _buildInfoRow(
                              icon: Icons.location_on,
                              text: artist!['location'] ?? 'Lokasi belum diisi',
                            ),

                            SizedBox(height: 6),

                            _buildInfoRow(
                              icon: Icons.calendar_today,
                              text: 'Jadwal Makeup: Tersedia',
                            ),

                            SizedBox(height: 16),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/booking',
                                    arguments: {
                                      "package_id": artist?['package_id'],
                                      "mua_id": artist?['id'],
                                      "price": artist?['price'],
                                      "biaya_admin":
                                          artist?['biaya_admin'] ?? 2000,
                                      "total": artist?['total'],
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(
                                    228,
                                    207,
                                    206,
                                    1,
                                  ),
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  'BOOKING SEKARANG',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // DESCRIPTION SECTION
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tentang Saya',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      SizedBox(height: 10),

                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          artist!['description'] ?? "Belum ada deskripsi",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, thickness: 1, color: Colors.grey[200]),

                // GALLERY SECTION
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Portofolio',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      SizedBox(height: 15),

                      if ((artist!['gallery'] as List<dynamic>?)?.isEmpty ??
                          true)
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.photo_library,
                                size: 60,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Belum ada portofolio',
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        )
                      else
                        GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 0.8,
                              ),
                          itemCount:
                              (artist!['gallery'] as List<dynamic>?)?.length ??
                              0,
                          itemBuilder: (context, index) {
                            final url = artist!['gallery']?[index] ?? '';
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: url.isNotEmpty
                                  ? Image.network(
                                      url,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Container(
                                              color: Colors.grey[200],
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[200],
                                              child: Icon(Icons.broken_image),
                                            );
                                          },
                                    )
                                  : Container(
                                      color: Colors.grey[200],
                                      child: Icon(Icons.photo),
                                    ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget
  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black54),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
