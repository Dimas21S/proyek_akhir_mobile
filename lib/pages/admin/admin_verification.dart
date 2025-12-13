import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AdminVerification extends StatefulWidget {
  const AdminVerification({super.key});

  @override
  State<AdminVerification> createState() => _AdminVerificationState();
}

class _AdminVerificationState extends State<AdminVerification> {
  List<dynamic> artistVerification = [];
  bool isLoading = true;

  Future<List<dynamic>> getVerifikasi() async {
    final url = Uri.parse("http://192.168.1.6:8000/api/verification");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data']['data'] ?? [];
    } else {
      return [];
    }
  }

  Future<void> updateStatus(int verificationId, String status) async {
    final url = Uri.parse(
      "http://192.168.1.6:8000/api/verification/$verificationId",
    );
    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"status": status}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Status berhasil diupdate')));
      await loadArtist(); // Refresh data
    } else {
      print('Error ${response.statusCode}: ${response.body}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal update status')));
    }
  }

  Future<void> loadArtist() async {
    artistVerification = await getVerifikasi();
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
            onPressed: () {},
            child: const Text(
              'Glamgate',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'ClientSphere',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : artistVerification.isEmpty
            ? const Center(child: Text("Belum ada data Make Up Artist"))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: artistVerification.length,
                itemBuilder: (context, index) {
                  final artist = artistVerification[index];
                  print(jsonEncode(artist));
                  final verificationId = artist['id'];
                  final status = artist['status'];
                  final name = artist['make_up_artist']['username'] ?? '-';
                  final time = artist['created_at'] ?? '-';
                  final address =
                      artist['make_up_artist']['address']?['full_address'] ??
                      '-';

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          artist['make_up_artist']['profile_photo'] ?? '',
                        ),
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            time,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // STATUS
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: status == 'accepted'
                                  ? Colors.green.withOpacity(0.2)
                                  : status == 'rejected'
                                  ? Colors.red.withOpacity(0.2)
                                  : Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: status == 'approved'
                                    ? Colors.green
                                    : status == 'rejected'
                                    ? Colors.red
                                    : Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),

                      trailing: const Icon(Icons.info, color: Colors.blue),
                      onTap: () {
                        // POPUP DETAIL
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Detail Make Up Artist'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nama: $name'),
                                  const SizedBox(height: 10),
                                  Text('Waktu: $time'),
                                  const SizedBox(height: 10),
                                  Text('Alamat: $address'),
                                ],
                              ),
                              actions: [
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => updateStatus(
                                        artist['id'],
                                        'accepted',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      child: const Text('Setuju'),
                                    ),
                                    const SizedBox(height: 5),
                                    ElevatedButton(
                                      onPressed: () => updateStatus(
                                        artist['id'],
                                        'rejected',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text('Tolak'),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
