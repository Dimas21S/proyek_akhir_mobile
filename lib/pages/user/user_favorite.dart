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
        title: Image.asset(
          'assets/images/logofullnyah.png',
          height: 40,
          fit: BoxFit.contain,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              textStyle: const TextStyle(fontSize: 12),
            ),
            child: const Text(
              'Home',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/lokasi'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              textStyle: const TextStyle(fontSize: 12),
            ),
            child: const Text(
              'Location',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/favorit'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              textStyle: const TextStyle(fontSize: 12),
            ),
            child: const Text(
              'Favorites',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/profil'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              textStyle: const TextStyle(fontSize: 12),
            ),
            child: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(249, 245, 243, 1),
                Color.fromRGBO(252, 250, 249, 1),
                Colors.white,
              ],
              stops: [0.0, 0.4, 1.0],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Favorites',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[900],
                          letterSpacing: -0.5,
                        ),
                      ),
                      Badge(
                        label: Text(
                          likedArtists.length.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: const Color.fromRGBO(228, 207, 206, 1),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Artists you\'ve liked will appear here',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),

                const SizedBox(height: 24),

                // Content Section
                Expanded(
                  child: likedArtists.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.favorite_border,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'No favorites yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Like some artists to see them here',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                              const SizedBox(height: 24),
                              // ElevatedButton(
                              //   onPressed: () {
                              //     Navigator.pushReplacementNamed(context, '/');
                              //   },
                              //   style: ElevatedButton.styleFrom(
                              //     backgroundColor: const Color.fromRGBO(
                              //       228,
                              //       207,
                              //       206,
                              //       1,
                              //     ),
                              //     foregroundColor: Colors.black87,
                              //     padding: const EdgeInsets.symmetric(
                              //       horizontal: 24,
                              //       vertical: 12,
                              //     ),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(8),
                              //     ),
                              //   ),
                              //   child: const Text(
                              //     'Browse Artists',
                              //     style: TextStyle(fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 20,
                            alignment: WrapAlignment.start,
                            children: List.generate(likedArtists.length, (
                              index,
                            ) {
                              final artist = likedArtists[index];

                              return SizedBox(
                                width: 172,
                                child: Material(
                                  elevation: 1,
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white,
                                  child: InkWell(
                                    onTap: () {
                                      // Navigate to artist detail
                                      // Navigator.pushNamed(context, '/artist-detail', arguments: artist);
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey[100]!,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Artist Image
                                          Container(
                                            height: 140,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                      16,
                                                    ),
                                                    topRight: Radius.circular(
                                                      16,
                                                    ),
                                                  ),
                                              image: DecorationImage(
                                                image:
                                                    artist['profile_photo'] !=
                                                            null &&
                                                        artist['profile_photo']
                                                            .isNotEmpty
                                                    ? NetworkImage(
                                                            artist['profile_photo'],
                                                          )
                                                          as ImageProvider
                                                    : const AssetImage(
                                                        'assets/images/logofullnyah.png',
                                                      ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                // Gradient Overlay
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                16,
                                                              ),
                                                          topRight:
                                                              Radius.circular(
                                                                16,
                                                              ),
                                                        ),
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.transparent,
                                                        Colors.black
                                                            .withOpacity(0.05),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                // Favorite Icon
                                                Positioned(
                                                  top: 8,
                                                  right: 8,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                          blurRadius: 4,
                                                        ),
                                                      ],
                                                    ),
                                                    child: const Icon(
                                                      Icons.favorite,
                                                      size: 16,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Artist Info
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  artist['name'] ??
                                                      'Unknown Artist',
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),

                                                const SizedBox(height: 6),

                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.category,
                                                      size: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        artist['category'] ??
                                                            'General',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 8),

                                                // Location Row
                                                if (artist['location'] != null)
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        size: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Expanded(
                                                        child: Text(
                                                          artist['location']!,
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: Colors
                                                                .grey[500],
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                const SizedBox(height: 12),

                                                // View Profile Button
                                                SizedBox(
                                                  width: double.infinity,
                                                  height: 32,
                                                  child: OutlinedButton(
                                                    onPressed: () {
                                                      // Navigate to artist profile
                                                    },
                                                    style: OutlinedButton.styleFrom(
                                                      side: BorderSide(
                                                        color:
                                                            const Color.fromRGBO(
                                                              228,
                                                              207,
                                                              206,
                                                              1,
                                                            ),
                                                        width: 1.2,
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                    child: Text(
                                                      'View Profile',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            const Color.fromRGBO(
                                                              228,
                                                              207,
                                                              206,
                                                              1,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
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
                            }),
                          ),
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
