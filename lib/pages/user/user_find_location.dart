import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class UserFindLocation extends StatefulWidget {
  const UserFindLocation({super.key});

  @override
  State<UserFindLocation> createState() => _UserFindLocationState();
}

class _UserFindLocationState extends State<UserFindLocation> {
  final TextEditingController searchController = TextEditingController();

  String searchText = "";
  List<dynamic> muaList = [];

  String selectedLocation = "all";
  List<String> locationList = [
    "all",
    "jambi-timur",
    "jelutung",
    "pasar-jambi",
    "alamt-teaah",
  ];

  String selectedKecamatan = "all";
  List<String> kecamatanList = ["all", "Telanaipura", "Jelutung", "Paal Merah"];
  List<dynamic> artistLocation = [];
  bool isLoading = true;

  Future<List<dynamic>> getLocation() async {
    final url = Uri.parse("http://192.168.1.6:8000/api/artist-location")
        .replace(
          queryParameters: {
            "search": searchText,
            "location": selectedLocation,
            "kecamatan": selectedKecamatan,
          },
        );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data'];
    } else {
      return [];
    }
  }

  Future<void> loadArtist() async {
    setState(() => isLoading = true);
    final data = await getLocation();
    setState(() {
      artistLocation = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadArtist();
  }

  String? dropdownValue;

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
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              textStyle: const TextStyle(fontSize: 12),
            ),
            child: const Text('Home', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/lokasi');
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              textStyle: const TextStyle(fontSize: 12),
            ),
            child: const Text(
              'Location',
              style: TextStyle(color: Colors.black),
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
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profil');
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              textStyle: const TextStyle(fontSize: 12),
            ),
            child: const Text('Profile', style: TextStyle(color: Colors.black)),
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(223, 219, 220, 1),
              Color.fromRGBO(230, 219, 217, 1),
              Color.fromRGBO(228, 207, 206, 1),
              Color.fromRGBO(211, 206, 229, 1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // HEADER SECTION
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Search and Filter Section
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: SearchAnchor(
                                builder: (context, controller) {
                                  return SearchBar(
                                    hintText: 'Search artist or location...',
                                    controller: searchController,
                                    textStyle:
                                        MaterialStateTextStyle.resolveWith(
                                          (states) =>
                                              const TextStyle(fontSize: 14),
                                        ),
                                    onSubmitted: (value) {
                                      setState(() {
                                        searchText = value;
                                      });
                                      loadArtist();
                                      controller.closeView(
                                        searchController.text,
                                      );
                                    },
                                    leading: const Icon(Icons.search, size: 20),
                                  );
                                },
                                suggestionsBuilder: (context, controller) {
                                  return List<ListTile>.generate(5, (index) {
                                    final suggestion = 'Suggestion $index';
                                    return ListTile(
                                      leading: const Icon(
                                        Icons.person,
                                        size: 20,
                                      ),
                                      title: Text(suggestion),
                                      onTap: () {
                                        searchController.text = suggestion;
                                        controller.closeView(suggestion);
                                        setState(() {
                                          searchText = suggestion;
                                        });
                                        loadArtist();
                                      },
                                    );
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButton<String>(
                                value: selectedLocation,
                                underline: const SizedBox(),
                                icon: const Icon(Icons.filter_list, size: 20),
                                elevation: 0,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    selectedLocation = value!;
                                  });
                                  loadArtist();
                                },
                                items: locationList.map((loc) {
                                  return DropdownMenuItem(
                                    value: loc,
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        minWidth: 80,
                                      ),
                                      child: Text(
                                        loc.toUpperCase(),
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // CONTENT SECTION
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Results Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Available Artists',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            '${artistLocation.length} results',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Artists List
                      isLoading
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 100,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color.fromRGBO(228, 207, 206, 1),
                                ),
                              ),
                            )
                          : artistLocation.isEmpty
                          ? Container(
                              padding: const EdgeInsets.symmetric(vertical: 60),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 60,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No artists found',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Try changing your search or filter',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: List.generate(artistLocation.length, (
                                index,
                              ) {
                                final artist = artistLocation[index];

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: Material(
                                    elevation: 1,
                                    borderRadius: BorderRadius.circular(12),
                                    child: InkWell(
                                      onTap: () {
                                        // Navigate to artist detail
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            // Avatar
                                            CircleAvatar(
                                              radius: 26,
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                    228,
                                                    207,
                                                    206,
                                                    0.3,
                                                  ),
                                              child:
                                                  artist['profile_photo'] !=
                                                      null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            26,
                                                          ),
                                                      child: Image.network(
                                                        artist['profile_photo'],
                                                        width: 52,
                                                        height: 52,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            26,
                                                          ),
                                                      child: Image.asset(
                                                        'assets/images/avatar.png',
                                                        width: 52,
                                                        height: 52,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                            ),

                                            const SizedBox(width: 16),

                                            // Artist Info
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    artist['name'] ??
                                                        "Unknown Artist",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        size: 14,
                                                        color: Colors.grey[600],
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Expanded(
                                                        child: Text(
                                                          artist['address']?['kecamatan'] ??
                                                              'Location not specified',
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  if (artist['category'] !=
                                                      null) ...[
                                                    const SizedBox(height: 4),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 2,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            const Color.fromRGBO(
                                                              228,
                                                              207,
                                                              206,
                                                              0.2,
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        artist['category'],
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          color: Color.fromRGBO(
                                                            228,
                                                            207,
                                                            206,
                                                            1,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),

                                            // Navigation Icon
                                            Icon(
                                              Icons.chevron_right,
                                              color: Colors.grey[400],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
        ),
        child: const Text(
          '© 2025 pakaimua. All rights reserved.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 11),
        ),
      ),
    );
  }
}
