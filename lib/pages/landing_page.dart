import 'package:flutter/material.dart';
import 'dart:ui';
import 'about_us.dart'; // Pastikan file ini ada
import 'contact_us.dart'; // Pastikan file ini ada

class LandingPage extends StatelessWidget {
  void _showSignInOptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              Icon(
                Icons.login,
                size: 40,
                color: const Color.fromRGBO(228, 207, 206, 1),
              ),
              const SizedBox(height: 12),
              const Text(
                'Sign In As',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // User Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/signin-user');
                  },
                  icon: const Icon(Icons.person_outline, size: 20),
                  label: const Text('User'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Makeup Artist Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/signin-artist');
                  },
                  icon: const Icon(Icons.brush_outlined, size: 20),
                  label: const Text('Makeup Artist'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(228, 207, 206, 1),
                    foregroundColor: Colors.black87,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double scale = screenWidth / 360; // Base 360dp

    // ┌──────────────────────────────┐
    // │ SESUAIKAN UKURAN FONT DI SINI │
    // └──────────────────────────────┘
    final double titleFontSize = 20 * scale;
    final double subtitleFontSize = 15 * scale;
    final double smallTextFontSize = 10 * scale; // 🔹 Untuk deskripsi
    final double navFontSize = 14 * scale;

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   surfaceTintColor: Colors.transparent,
      //   title: Image.asset('assets/images/logofullnyah.png'),
      //   elevation: 0,
      //   centerTitle: true,
      //   actions: [
      //     TextButton(
      //       onPressed: () => Navigator.pushReplacementNamed(context, '/'),
      //       style: TextButton.styleFrom(
      //         padding: const EdgeInsets.symmetric(horizontal: 12),
      //         textStyle: const TextStyle(fontSize: 12),
      //       ),
      //       child: const Text(
      //         'Collect',
      //         style: TextStyle(
      //           color: Colors.black87,
      //           fontSize: 14,
      //           fontWeight: FontWeight.w500,
      //         ),
      //       ),
      //     ),
      //     TextButton(
      //       onPressed: () => Navigator.pushReplacementNamed(context, '/'),
      //       style: TextButton.styleFrom(
      //         padding: const EdgeInsets.symmetric(horizontal: 12),
      //         textStyle: const TextStyle(fontSize: 12),
      //       ),
      //       child: const Text(
      //         'About',
      //         style: TextStyle(
      //           color: Colors.black87,
      //           fontSize: 14,
      //           fontWeight: FontWeight.w500,
      //         ),
      //       ),
      //     ),
      //     TextButton(
      //       onPressed: () => Navigator.pushReplacementNamed(context, '/'),
      //       style: TextButton.styleFrom(
      //         padding: const EdgeInsets.symmetric(horizontal: 12),
      //         textStyle: const TextStyle(fontSize: 12),
      //       ),
      //       child: const Text(
      //         'Contact',
      //         style: TextStyle(
      //           color: Colors.black87,
      //           fontSize: 14,
      //           fontWeight: FontWeight.w500,
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 1050 * scale + MediaQuery.of(context).padding.top + 20,
          child: Stack(
            children: [
              // 1. Area Status Bar Putih
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).padding.top + 20,
                child: Container(color: Colors.white),
              ),

              // Background Gambar
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bgLPGC.png'),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
              ),

              // Overlay Gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // 3. NAVBAR
              Positioned(
                top: MediaQuery.of(context).padding.top + 4 * scale,
                left: 18 * scale,
                right: 20 * scale,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    Container(
                      height: 48 * scale,
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/images/logofullnyah.png',
                        fit: BoxFit.contain,
                        height: 48 * scale,
                      ),
                    ),

                    // Navigasi
                    Row(
                      children: [
                        Text(
                          'Collect',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: navFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 16 * scale),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AboutUsPage(),
                              ),
                            );
                          },
                          child: Text(
                            'About',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: navFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: 16 * scale),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactUsPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Contact',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: navFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // // 4. Judul Utama
              Positioned(
                top: 50 * scale + MediaQuery.of(context).padding.top + 20,
                left: 20 * scale,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'pakaimua.com Collection',
                      style: TextStyle(
                        fontFamily: 'DMSerifDisplay',
                        fontWeight: FontWeight.bold,
                        fontSize: titleFontSize,
                        color: Colors.black,
                        shadows: [
                          Shadow(
                            blurRadius: 1,
                            color: Colors.grey.withOpacity(0.3),
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5 * scale),
                    Text(
                      'New Coming',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // 5. Button Sign In & Sign Up
              Positioned(
                top: 130 * scale + MediaQuery.of(context).padding.top + 20,
                left: 20 * scale,
                child: Row(
                  children: [
                    Container(
                      height: 40 * scale,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16 * scale,
                        vertical: 8 * scale,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF8D6E63),
                        borderRadius: BorderRadius.circular(8 * scale),
                      ),
                      child: TextButton(
                        onPressed: () => _showSignInOptionDialog(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10 * scale),
                    Container(
                      height: 40 * scale,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16 * scale,
                        vertical: 8 * scale,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF8D6E63)),
                        borderRadius: BorderRadius.circular(8 * scale),
                      ),
                      child: TextButton(
                        onPressed: () => _showSignInOptionDialog(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 6. 🔶 2 KOTAK BARU — TEKS CENTER HORIZONTAL & UKURAN BISA DIKURANGI SENDIRI
              Positioned(
                top: 200 * scale + MediaQuery.of(context).padding.top + 20,
                left: 0,
                right: 0,
                child: Center(
                  // 🔸 Agar tetap di tengah layar
                  child: SizedBox(
                    width:
                        280 *
                        scale, // ⬅️ 🔑 UBAH ANGKA INI UNTUK ATUR JARAK ANTAR KOTAK!
                    // Semakin kecil → semakin dekat kotaknya
                    // Coba: 260, 240, 220, dst.
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // ✅ Tetap dipakai
                      children: [
                        // Kotak Kiri (TIDAK DIUBAH SAMA SEKALI)
                        Container(
                          width: 130 * scale,
                          padding: EdgeInsets.all(10 * scale),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12 * scale),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 4 * scale,
                                offset: Offset(0, 2 * scale),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Inspirasi & Kreasi Tanpa Batas',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11 * scale,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 6 * scale),
                              Text(
                                'Jelajahi berbagai gaya riasan, temukan teknik terbaik, dan wujudkan tampilan impianmu dengan sentuhan profesional.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 9 * scale,
                                  color: Colors.black.withOpacity(0.7),
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Kotak Kanan (TIDAK DIUBAH SAMA SEKALI)
                        Container(
                          width: 130 * scale,
                          padding: EdgeInsets.all(16 * scale),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12 * scale),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 4 * scale,
                                offset: Offset(0, 2 * scale),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Tampil Memukau di Setiap Momen',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11 * scale,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 6 * scale),
                              Text(
                                'Di sini, kecantikan bukan hanya tentang makeup, tapi juga tentang ekspresi diri yang unik.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 9 * scale,
                                  color: Colors.black.withOpacity(0.7),
                                  height: 1.3,
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

              // 7. 🔷 JUDUL "MENGAPA MEMILIH KAMI" — DITAMBAHKAN DI ANTARA 2 KOTAK & 4 ITEM MATERIAL
              Positioned(
                top: 370 * scale + MediaQuery.of(context).padding.top + 20,
                left: 20 * scale,
                right: 20 * scale,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'MENGAPA MEMILIH KAMI',
                      style: TextStyle(
                        color: Color(0xFFE53935), // Merah
                        fontSize: 10 * scale,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 4 * scale),
                    Text(
                      'People choose us because we serve the best for everyone',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16 * scale,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              // 8. 🔷 4 ITEM MATERIAL — DIBAGI 2 BARIS, TEKS DI SAMPING GAMBAR (SESUAI PERMINTAANMU)
              Positioned(
                top: 440 * scale + MediaQuery.of(context).padding.top + 20,
                left: 20 * scale,
                right: 20 * scale,
                child: Column(
                  children: [
                    // Baris 1: Ungu & Merah
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMaterialItemHorizontal(
                          context,
                          image: 'assets/images/lpungu.png',
                          title: 'Inspirasi & Tren Kecantikan Terbaru',
                          subtitle:
                              'Hasil riasan yang memukau dari para makeup artist berbakat, memastikan setiap tampilan terlihat sempurna dan sesuai dengan karakter unikmu.',
                          scale: scale,
                        ),
                        _buildMaterialItemHorizontal(
                          context,
                          image: 'assets/images/lpmerah.png',
                          title: 'Tampilan Keunikan Dirimu dengan Makeup',
                          subtitle:
                              'Kami percaya bahwa setiap orang memiliki kecantikan yang khas. MUAku membantu menonjolkan gaya dan kepribadianmu melalui riasan yang sesuai denganmu!',
                          scale: scale,
                        ),
                      ],
                    ),
                    SizedBox(height: 20 * scale), // Jarak antar baris
                    // Baris 2: Hijau & Hitam
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMaterialItemHorizontal(
                          context,
                          image: 'assets/images/lphijau.png',
                          title: 'Riasan Berkualitas, Hasil Memukau',
                          subtitle:
                              'Hasil riasan yang memukau dari para makeup artist berbakat, memastikan setiap tampilan terlihat sempurna dan sesuai dengan karakter unikmu.',
                          scale: scale,
                        ),
                        _buildMaterialItemHorizontal(
                          context,
                          image: 'assets/images/lphitam.png',
                          title: 'Temukan & Pilih MUA Favoritmu dengan Mudah',
                          subtitle:
                              'Hasil riasan yang memukau dari para makeup artist berbakat, memastikan setiap tampilan terlihat sempurna dan sesuai dengan karakter unikmu.',
                          scale: scale,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 9. 🔷 "TENTANG KAMI" + BUTTON — SESUAI GAMBAR (diposisikan dengan gap aman)
              Positioned(
                top: 650 * scale + MediaQuery.of(context).padding.top + 20,
                left: 20 * scale,
                right: 20 * scale,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul + Button
                    Row(
                      children: [
                        Text(
                          'Tentang Kami',
                          style: TextStyle(
                            fontSize: 18 * scale,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Spacer(), // Push button ke kanan
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12 * scale,
                            vertical: 6 * scale,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF1976D2), // Biru Material
                            borderRadius: BorderRadius.circular(6 * scale),
                          ),
                          child: Text(
                            'Lihat Selengkapnya',
                            style: TextStyle(
                              fontSize: 12 * scale,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8 * scale),
                    // Deskripsi
                    Text(
                      'Kami adalah platform yang menghubungkan para makeup artist berbakat dengan klien yang ingin tampil memukau di setiap momen. Dengan pakaimua.com, kamu bisa menemukan MUA terbaik sesuai gaya dan kebutuhanmu.',
                      style: TextStyle(
                        fontSize: 11 * scale,
                        color: Colors.black.withOpacity(0.7),
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              Positioned(
                top: 800 * scale + MediaQuery.of(context).padding.top + 20,
                left: 20 * scale,
                right: 20 * scale,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul + Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Seni Kecantikan',
                              style: TextStyle(
                                fontSize: 18 * scale,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),

                            SizedBox(height: 10),

                            Text(
                              "Kami menghadirkan para makeup artist berbakat dengan hasil karya terbaik, mulai dari tampilan alami yang elegan hingga kreasi bold yang memukau.",
                              style: TextStyle(
                                fontSize: 11 * scale,
                                color: Colors.black.withOpacity(0.7),
                                height: 1.4,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),

                        // Push button ke kanan
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/lpseni.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        color: Colors.white,
        child: const Text(
          '© 2025 pakaimua. All rights reserved.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }

  // 🔹 GANTI FUNGSI INI: sekarang teks di samping gambar (horizontal layout)
  Widget _buildMaterialItemHorizontal(
    BuildContext context, {
    required String image,
    required String title,
    required String subtitle,
    required double scale,
  }) {
    return Container(
      width: (MediaQuery.of(context).size.width - 60 * scale) / 2,
      padding: EdgeInsets.all(12 * scale),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4 * scale,
            offset: Offset(0, 2 * scale),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40 * scale,
            height: 40 * scale,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: 12 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11 * scale,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4 * scale),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 8 * scale,
                    color: Colors.black.withOpacity(0.7),
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
