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
            child: Padding(
              padding: const EdgeInsets.all(16.0),

              // Semua konten di sini
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SearchAnchor(
                          builder: (context, controller) {
                            return SearchBar(
                              hintText: 'Search...',
                              controller: searchController,
                              onSubmitted: (value) {
                                setState(() {
                                  searchText = value;
                                });
                                loadArtist();
                                controller.closeView(searchController.text);
                              },
                            );
                          },
                          suggestionsBuilder: (context, controller) {
                            return List<ListTile>.generate(5, (index) {
                              final suggestion = 'Suggestion $index';
                              return ListTile(
                                title: Text(suggestion),
                                onTap: () {
                                  searchController.text;
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

                      const SizedBox(width: 8),

                      DropdownButton<String>(
                        value: selectedLocation,
                        onChanged: (value) {
                          setState(() {
                            selectedLocation = value!;
                          });
                          loadArtist(); // SEHARUSNYA loadArtist(), bukan getLocation()
                        },
                        items: locationList.map((loc) {
                          return DropdownMenuItem(
                            value: loc,
                            child: Text(loc.toUpperCase()),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // CARD
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          children: List.generate(artistLocation.length, (
                            index,
                          ) {
                            final artist = artistLocation[index];

                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    // FOTO / AVATAR
                                    const CircleAvatar(
                                      radius: 22,
                                      backgroundImage: AssetImage(
                                        'assets/images/avatar.png',
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    // INFORMASI ARTIS
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            artist['name'] ?? "Tidak ada nama",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "Location: ${artist['address']?['kecamatan'] ?? 'Tidak diketahui'}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      artist['address']?['kecamatan'] ?? "-",
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
