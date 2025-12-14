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
      body: CustomScrollView(
        slivers: [
          // SLIVER APP BAR DENGAN FOTO PROFIL FULL WIDTH
          SliverAppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
            expandedHeight: 300, // Tinggi ketika expanded
            floating: false,
            pinned: true, // Tetap visible saat collapse
            snap: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // FOTO PROFIL FULL WIDTH
                  Positioned.fill(
                    child: artist!['profile_photo'] != null
                        ? Image.network(
                            artist!['profile_photo'],
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/user_sign_in.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                  // GRADIENT OVERLAY untuk readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                          Colors.transparent,
                        ],
                        stops: [0.1, 0.5, 1.0],
                      ),
                    ),
                  ),
                  // INFO ARTIST DI BAWAH FOTO
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          artist!['username'] ?? 'Nama Artist',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(blurRadius: 6, color: Colors.black),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          artist!['category'] ?? 'Makeup Artist',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(blurRadius: 4, color: Colors.black),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              title: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  artist!['username'] ?? 'Artist',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              centerTitle: true,
              collapseMode: CollapseMode.pin,
            ),
            actions: [
              // Action buttons dengan background semi-transparan
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        toggleLike(artist!['id']);
                      },
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.white,
                        size: 22,
                      ),
                      tooltip: 'Like',
                    ),
                    Container(
                      height: 20,
                      width: 1,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/artist-to-user',
                          arguments: artist,
                        );
                      },
                      icon: Icon(Icons.chat, color: Colors.white, size: 22),
                      tooltip: 'Chat',
                    ),
                    Container(
                      height: 20,
                      width: 1,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/rating',
                          arguments: artist?['id'],
                        );
                      },
                      icon: Icon(Icons.star, color: Colors.white, size: 22),
                      tooltip: 'Rating',
                    ),
                  ],
                ),
              ),
            ],
          ),

          // KONTEN UTAMA
          SliverList(
            delegate: SliverChildListDelegate([
              // INFO DETAIL SECTION
              Container(
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // WhatsApp Button terpisah
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: ElevatedButton.icon(
                    //     onPressed: () {
                    //       final phone = artist!['phone'];
                    //       if (phone != null) {
                    //         // Implement WhatsApp launch
                    //       }
                    //     },
                    //     icon: Icon(Icons.chat_bubble, color: Colors.white),
                    //     label: Text(
                    //       'Hubungi via WhatsApp',
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.w600,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.green,
                    //       padding: EdgeInsets.symmetric(vertical: 14),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       elevation: 3,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 20),

                    // Info lengkap artist
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          icon: Icons.phone,
                          text: artist!['phone'] ?? 'Telepon belum diisi',
                        ),
                        SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.location_on,
                          text: artist!['location'] ?? 'Lokasi belum diisi',
                        ),
                        SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.calendar_today,
                          text: 'Jadwal Makeup: Tersedia',
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // BOOKING BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/booking',
                            arguments: {'artistId': artist!['id']},
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(228, 207, 206, 1),
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                        child: Text(
                          'BOOKING SEKARANG',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // DESCRIPTION SECTION
              Container(
                color: Colors.white,
                child: Padding(
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
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          artist!['description'] ?? "Belum ada deskripsi",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Divider(height: 1, thickness: 1, color: Colors.grey[200]),

              // GALLERY SECTION
              Container(
                color: Colors.white,
                child: Padding(
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
                      SizedBox(height: 16),

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
                              SizedBox(height: 12),
                              Text(
                                'Belum ada portofolio',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
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
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.85,
                              ),
                          itemCount:
                              (artist!['gallery'] as List<dynamic>?)?.length ??
                              0,
                          itemBuilder: (context, index) {
                            final url = artist!['gallery']?[index] ?? '';
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
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
                                              child: Icon(
                                                Icons.broken_image,
                                                color: Colors.grey[400],
                                              ),
                                            );
                                          },
                                    )
                                  : Container(
                                      color: Colors.grey[200],
                                      child: Icon(
                                        Icons.photo,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20), // Extra spacing bottom
            ]),
          ),
        ],
      ),
    );
  }

  // Helper Widget - TETAP SAMA
  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Color.fromRGBO(228, 207, 206, 1)),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
