import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF3E9FF), // ungu muda
                Color(0xFFC8B6E2), // ungu sedang
                Color(0xFF7C677F), // ungu tua
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // BAGIAN HEADER DENGAN GAMBAR
                Stack(
                  children: [
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/about_us.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Tombol Back - AMBIL DARI ASSETS
                    Positioned(
                      top: 10,
                      left: 10,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/back_about_us.png',
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) {
                              return Icon(
                                Icons.arrow_back,
                                color: Colors.purple[800],
                                size: 24,
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Text "Contact"
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          "Contact",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                offset: Offset(1, 1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // CARD UNTUK FORM CONTACT — DENGAN BACKGROUND GAMBAR ABSTRAK
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                    color:
                        Colors.transparent, // Agar background gambar terlihat
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/contact_us_bg.png",
                          ), // 👈 GANTI DENGAN NAMA FILE ANDA
                          fit: BoxFit.cover,
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Judul & Subjudul — Gunakan warna putih agar kontras
                          const Text(
                            "Contact Information",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Say something to start a live chat",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Informasi Kontak — Gunakan ikon dan teks putih
                          _buildContactRow(Icons.phone, "+62 852 6968 5106"),
                          const SizedBox(height: 12),
                          _buildContactRow(
                            Icons.email,
                            "pakaimua100@gmail.com",
                          ),
                          const SizedBox(height: 12),
                          _buildContactRow(Icons.location_on, "Mendalo"),
                          const SizedBox(height: 30),

                          // Form Input — Gunakan TextField dengan background putih transparan
                          _buildTextField("Nama Depan", "Masukkan Nama Depan"),
                          const SizedBox(height: 16),
                          _buildTextField(
                            "Nama Belakang",
                            "Masukkan Nama Belakang",
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  "Email",
                                  "Masukkan Email",
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField("Phone Number", "+62"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Select Subject? — SATU BARIS SAJA
                          const Text(
                            "Select Subject?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildRadioOption("Layanan", true),
                              _buildRadioOption("Bantuan & Dukungan", false),
                              _buildRadioOption("Saran & Masukan", false),
                              _buildRadioOption("Lainnya", false),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Message Field
                          const Text(
                            "Message",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: "Masukkan Pesan",
                              hintStyle: TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 24),

                          // Send Button
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Pesan terkirim!"),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF7C677F),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                "Send Message",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // FOOTER
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "© 2025 pakaimua. All rights reserved.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
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

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildTextField(String label, String hint) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white70),
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildRadioOption(String label, bool isSelected) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<bool>(
            value: isSelected,
            groupValue: isSelected,
            onChanged: (value) {},
            activeColor: Colors
                .white, // Ubah warna radio button jadi putih agar terlihat
          ),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.white),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
