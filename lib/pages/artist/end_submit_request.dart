import 'package:flutter/material.dart';

class EndSubmitRequest extends StatefulWidget {
  const EndSubmitRequest({super.key});

  @override
  State<EndSubmitRequest> createState() => _EndSubmitRequestState();
}

class _EndSubmitRequestState extends State<EndSubmitRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(228, 207, 206, 1),
              Color.fromRGBO(228, 207, 206, 0.8),
              Colors.white,
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Icon
                  Container(
                    width: 120,
                    height: 120,
                    margin: const EdgeInsets.only(bottom: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(
                            228,
                            207,
                            206,
                            1,
                          ).withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer Ring
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color.fromRGBO(228, 207, 206, 1),
                              width: 3,
                            ),
                          ),
                        ),
                        // Check Mark
                        const Icon(
                          Icons.check_circle,
                          size: 80,
                          color: Color.fromRGBO(228, 207, 206, 1),
                        ),
                      ],
                    ),
                  ),

                  // Success Title
                  Text(
                    'Pendaftaran Berhasil!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[900],
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Message Container
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: Border.all(color: Colors.grey[100]!, width: 1),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Terima kasih sudah mendaftar sebagai Makeup Artist!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'Permintaan pendaftaran Anda sedang kami proses. Silakan menunggu verifikasi dari tim kami.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Timeline/Steps
                  Container(
                    margin: const EdgeInsets.only(bottom: 32),
                    child: Column(
                      children: [
                        _buildStep(
                          number: '1',
                          title: 'Pendaftaran Dikirim',
                          description: 'Data Anda telah berhasil dikirim',
                          isActive: true,
                        ),
                        _buildStepConnector(),
                        _buildStep(
                          number: '2',
                          title: 'Verifikasi Admin',
                          description: 'Tim kami akan memverifikasi data',
                          isActive: false,
                        ),
                        _buildStepConnector(),
                        _buildStep(
                          number: '3',
                          title: 'Akun Aktif',
                          description: 'Anda bisa mulai menerima booking',
                          isActive: false,
                        ),
                      ],
                    ),
                  ),

                  // Estimated Time
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color.fromRGBO(228, 207, 206, 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(228, 207, 206, 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.access_time,
                            color: Color.fromRGBO(228, 207, 206, 1),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Estimasi Waktu Verifikasi',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '1-3 hari kerja',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Next Steps
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[100]!, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(228, 207, 206, 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: Color.fromRGBO(228, 207, 206, 1),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Yang Harus Anda Lakukan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        _buildNextStepItem(
                          icon: Icons.email,
                          text: 'Periksa email Anda secara berkala',
                        ),
                        _buildNextStepItem(
                          icon: Icons.notifications,
                          text: 'Aktifkan notifikasi aplikasi',
                        ),
                        _buildNextStepItem(
                          icon: Icons.phone,
                          text: 'Pastikan nomor telepon aktif',
                        ),
                        _buildNextStepItem(
                          icon: Icons.person,
                          text: 'Siapkan portofolio Anda',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Action Buttons
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to home
                            Navigator.pushReplacementNamed(context, '/');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(
                              228,
                              207,
                              206,
                              1,
                            ),
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Kembali ke Beranda',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () {
                            // Contact support
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: const Color.fromRGBO(228, 207, 206, 1),
                              width: 1.5,
                            ),
                            foregroundColor: const Color.fromRGBO(
                              228,
                              207,
                              206,
                              1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.help_outline, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Butuh Bantuan?',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Footer Note
                  Text(
                    'Tim pakaimua akan menghubungi Anda segera setelah verifikasi selesai.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required String description,
    required bool isActive,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? const Color.fromRGBO(228, 207, 206, 1)
                : Colors.grey[200],
            border: Border.all(
              color: isActive
                  ? const Color.fromRGBO(228, 207, 206, 1)
                  : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white : Colors.grey[400],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.grey[900] : Colors.grey[500],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: isActive ? Colors.grey[600] : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector() {
    return Container(
      margin: const EdgeInsets.only(left: 19, top: 4, bottom: 4),
      width: 2,
      height: 30,
      color: Colors.grey[300],
    );
  }

  Widget _buildNextStepItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(228, 207, 206, 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: const Color.fromRGBO(228, 207, 206, 1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
