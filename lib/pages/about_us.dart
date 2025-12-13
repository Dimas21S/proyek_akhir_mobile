import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

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

                    // Tombol Back
                    Positioned(
                      top: 10,
                      left: 10,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/contact'),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          child: Image.asset(
                            'assets/images/back_about_us.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    // Text "About Us"
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          "About Us",
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

                // CARD UNTUK SEMUA TEKS DAN FRAME FOTO
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                    color: Colors.white.withOpacity(
                      0.85,
                    ), // Semi-transparan putih
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Paragraf Pertama
                          const Text(
                            "pakaimua adalah platform yang menghadirkan kreativitas dan keahlian dari para makeup artist berbakat. "
                            "Kami percaya bahwa setiap sentuhan kuas memiliki makna, menciptakan tampilan yang tidak hanya memperindah "
                            "tetapi juga mencerminkan kepribadian dan keunikan seseorang. "
                            "Di MUAku, kami menghubungkan para MUA profesional dengan mereka yang ingin tampil memukau, baik untuk acara spesial, "
                            "sesi pemotretan, atau sekadar mempercantik tampilan sehari-hari.",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.justify,
                          ),

                          const SizedBox(height: 20),

                          // FRAME DENGAN FOTO + TEKS (Paragraf Kedua)
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // FOTO DALAM FRAME
                                Container(
                                  width: 120,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/images/about_us1.png",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                // Teks di samping gambar
                                const Expanded(
                                  child: Text(
                                    "Selain menjadi wadah untuk menampilkan hasil riasan terbaik, "
                                    "MUAku juga menjadi sumber inspirasi dengan tren kecantikan terkini "
                                    "serta berbagai tips makeup.",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Paragraf Ketiga
                          const Text(
                            "Kami hadir untuk membantu setiap individu mengekspresikan dirinya melalui seni rias wajah, "
                            "memastikan mereka merasa percaya diri dan bersinar di setiap momen. "
                            "Jelajahi dunia kecantikan bersama MUAku dan temukan gaya terbaik untukmu!",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // FOOTER COPYRIGHT DI LUAR CARD
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
}
