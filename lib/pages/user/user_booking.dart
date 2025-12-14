import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UserBooking extends StatefulWidget {
  const UserBooking({super.key});

  @override
  State<UserBooking> createState() => _UserBookingState();
}

class _UserBookingState extends State<UserBooking> {
  Map<String, dynamic>? artistBooking;
  bool isLoading = true;
  late int artistId;
  late int packageId;
  late int muaId;
  late int price;
  late int total;

  int biayaAdmin = 2000;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   final args =
  //       ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

  //   print("DEBUG ARGS: $args");

  //   packageId = args["package_id"] as int;
  //   muaId = args["mua_id"] as int;
  //   price = args["price"] as int;
  //   total = price + 2000;
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int artistId = args['artistId'];

    // Panggil API dengan artistId
    loadArtist(artistId);
  }

  Future<Map<String, dynamic>?> fetchArtistBooking(int artistId) async {
    final url = Uri.parse('http://192.168.1.6:8000/api/booking/$artistId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['data'];
        } else {
          print("Gagal: ${data['message']}");
          return null;
        }
      } else {
        print("Server error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   loadArtist();
  // }

  // void setBookingData() {
  //   final package = artistBooking!['packages'];

  //   if (artistBooking == null || package == null) {
  //     print("❌ Data booking belum lengkap");
  //     return;
  //   }

  //   muaId = artistBooking['id'];
  //   packageId = package['id'];
  //   price = package['price'];
  //   total = price + biayaAdmin;
  // }

  void loadArtist(int artistId) async {
    var data = await fetchArtistBooking(artistId);

    if (data == null) {
      setState(() {
        artistBooking = null;
        isLoading = false;
      });
      return;
    }

    final package = data['packages'];

    if (package == null) {
      setState(() {
        artistBooking = null;
        isLoading = false;
      });
      return;
    }

    setState(() {
      artistBooking = data;
      muaId = data['id'];
      packageId = package['id'];
      price = package['price'];
      total = price + biayaAdmin;
      isLoading = false;
    });
  }

  Future<String?> getSnapToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("Token tidak ditemukan");
        return null;
      }

      final url = Uri.parse("http://192.168.1.6:8000/api/booking/snap-token");
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "package_id": packageId,
          "mua_id": muaId,
          "price": price,
          "total": total,
        }),
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return data['snap_token'];
      } else {
        print("Gagal: ${data['error']}");
        print("Body: ${response.body}");

        return null;
      }
    } catch (e) {
      print("Error getSnapToken: $e");
      return null;
    }
  }

  void openSnap(String snapToken) {
    final snapUrl = "https://app.sandbox.midtrans.com/snap/v2/vtweb/$snapToken";

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(snapUrl));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text("Pembayaran")),
            body: WebViewWidget(controller: controller),
          );
        },
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (artistBooking == null) {
      return const Scaffold(
        body: Center(child: Text("Data booking tidak ditemukan")),
      );
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(237, 239, 255, 1),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  const Center(
                    child: Text(
                      "Book Now",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(height: 1),

                  // Appointment Details
                  const SizedBox(height: 20),
                  const Text(
                    "Appointment Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),

                  _buildDetailRow("Nama MUA", artistBooking!['name']),
                  const SizedBox(height: 8),
                  _buildDetailRow("Kategori", artistBooking!['category']),

                  const SizedBox(height: 20),
                  const Divider(height: 1),

                  // Payment Details
                  const SizedBox(height: 20),
                  const Text(
                    "Payment Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),

                  _buildDetailRow(
                    "Harga",
                    artistBooking!['packages']['price'].toString(),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow("Admin Fee", "Rp $biayaAdmin"),

                  const SizedBox(height: 20),
                  const Divider(height: 1),

                  // Total
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Rp $total",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Pay Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(74, 108, 247, 1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () async {
                        String? snapToken = await getSnapToken();
                        if (snapToken != null) {
                          openSnap(snapToken);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Gagal mendapatkan Snap Token"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Bayar Sekarang",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method untuk menampilkan detail row
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
