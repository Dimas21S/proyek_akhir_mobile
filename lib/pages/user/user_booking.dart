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
  late int packageId;
  late int muaId;
  late int price;
  late int total;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    print("DEBUG ARGS: $args");

    packageId = args["package_id"];
    muaId = args["mua_id"];
    price = args["price"];
    total = args["total"];
  }

  Future<String?> getSnapToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("Token tidak ditemukan");
        return null;
      }

      final url = Uri.parse("http://192.168.1.6:8000/api/booking/$muaId");
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Book Now",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("Appointment"), Text("Nama MUA")],
                ),

                Text("Total Payment"),
                Text("Consultation Fee: "),
                Text("Admin Fee: "),

                Divider(),

                Text("Total: "),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      String? snapToken = await getSnapToken();
                      if (snapToken != null) {
                        openSnap(snapToken);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Gagal mendapatkan Snap Token"),
                          ),
                        );
                      }
                    },
                    child: const Text("Bayar", style: TextStyle(fontSize: 16)),
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
