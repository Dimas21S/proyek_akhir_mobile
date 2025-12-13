import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';

class EditProfil extends StatefulWidget {
  const EditProfil({super.key});

  @override
  State<EditProfil> createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linkMapController = TextEditingController();

  File? profilePhoto;
  String? selectedDay;
  int? selectedTimeOpen;
  int? selectedTimeClose;
  int? hargaPaket;
  List<File> photos = [];
  bool isLoading = false;

  List<String> days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  // List jam dari 00:00 sampai 23:30 (dalam menit)
  List<int> timeSlots = List.generate(48, (index) => index * 30);

  // Fungsi untuk mengubah menit ke format waktu
  String formatTime(int minutes) {
    final hour = (minutes ~/ 60).toString().padLeft(2, '0');
    final minute = (minutes % 60).toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  Future<void> _loadExistingData() async {
    // Tambahkan logika untuk memuat data profil yang sudah ada di sini
    // Contoh: fetch data dari API dan isi controllers
  }

  Future<void> _pickProfilePhoto() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          profilePhoto = File(result.files.first.path!);
        });
      }
    } catch (e) {
      print("Error picking profile photo: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memilih foto: $e")));
    }
  }

  Future<void> _pickGalleryPhotos() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          photos.addAll(result.files.map((file) => File(file.path!)).toList());
        });
      }
    } catch (e) {
      print("Error picking gallery photos: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memilih foto galeri: $e")));
    }
  }

  void _removeGalleryPhoto(int index) {
    setState(() {
      photos.removeAt(index);
    });
  }

  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Token tidak ditemukan. Silakan login ulang")),
        );
        return;
      }

      final uri = Uri.parse("http://192.168.1.6:8000/api/update-mua");
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.fields['name'] = nameController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['category'] = categoryController.text;
      request.fields['description'] = descriptionController.text;
      request.fields['link_map'] = linkMapController.text;

      // Tambahkan data jam operasional jika ada
      if (selectedDay != null &&
          selectedTimeOpen != null &&
          selectedTimeClose != null) {
        request.fields['hari'] = selectedDay!;
        request.fields['jam_buka'] = selectedTimeOpen!.toString();
        request.fields['jam_tutup'] = selectedTimeClose!.toString();
      }

      // Tambahkan profile_photo
      if (profilePhoto != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_photo',
            profilePhoto!.path,
          ),
        );
      }

      // Tambahkan photos galeri
      for (var i = 0; i < photos.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath('photos[]', photos[i].path),
        );
      }

      // Kirim request
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final data = jsonDecode(respStr);

      if (response.statusCode == 200 && data['success'] == true) {
        print("Profil berhasil diperbarui: ${data['data']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Profil berhasil diperbarui"),
            backgroundColor: Colors.green,
          ),
        );

        // Navigasi kembali setelah sukses (opsional)
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context, true); // Return true untuk refresh data
        });
      } else {
        print("Gagal update profil: $data");
        String errorMessage = data['message'] ?? "Gagal update profil";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print("Error update profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildPhotoPreview() {
    if (profilePhoto == null) {
      return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(Icons.person, size: 40, color: Colors.grey[400]),
      );
    }

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(48),
        child: Image.file(
          profilePhoto!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: Icon(Icons.error, color: Colors.red),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGalleryPreview() {
    if (photos.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            "Foto Galeri (${photos.length})",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.file(
                          photos[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Icon(Icons.error, color: Colors.red),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removeGalleryPhoto(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDaySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hari Operasional',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: days.map((day) {
            final isSelected = selectedDay == day;
            return ChoiceChip(
              label: Text(day),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedDay = selected ? day : null;
                });
              },
              selectedColor: Colors.blue.withOpacity(0.2),
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.blue : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected ? Colors.blue : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTimeOpenSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jam Buka',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedTimeOpen,
              isExpanded: true,
              hint: Text('Pilih Jam Buka'),
              items: timeSlots.map((minutes) {
                return DropdownMenuItem<int>(
                  value: minutes,
                  child: Text(formatTime(minutes)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTimeOpen = value;
                  // Validasi: jam tutup harus setelah jam buka
                  if (selectedTimeClose != null &&
                      value != null &&
                      selectedTimeClose! <= value) {
                    selectedTimeClose = null;
                  }
                });
              },
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTimeCloseSelector() {
    // Filter jam tutup yang valid (harus setelah jam buka)
    List<int> validCloseTimes = timeSlots.where((time) {
      if (selectedTimeOpen == null) return true;
      return time > selectedTimeOpen!;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jam Tutup',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedTimeClose,
              isExpanded: true,
              hint: Text(
                selectedTimeOpen == null
                    ? 'Pilih Jam Tutup'
                    : 'Pilih Jam Tutup (setelah ${formatTime(selectedTimeOpen!)})',
              ),
              items: validCloseTimes.map((minutes) {
                return DropdownMenuItem<int>(
                  value: minutes,
                  child: Text(formatTime(minutes)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTimeClose = value;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSelectedTimeDisplay() {
    if (selectedDay == null ||
        selectedTimeOpen == null ||
        selectedTimeClose == null) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[100]!),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, color: Colors.green),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Waktu Operasional:',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  '$selectedDay: ${formatTime(selectedTimeOpen!)} - ${formatTime(selectedTimeClose!)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.clear, size: 20),
            onPressed: () {
              setState(() {
                selectedDay = null;
                selectedTimeOpen = null;
                selectedTimeClose = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOperationalHoursSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        SizedBox(height: 16),
        Text(
          'Jam Operasional',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Atur hari dan jam operasional Anda',
          style: TextStyle(color: Colors.grey[600]),
        ),
        SizedBox(height: 16),

        // Pemilihan hari
        _buildDaySelector(),

        // Pemilihan jam buka
        _buildTimeOpenSelector(),

        // Pemilihan jam tutup
        _buildTimeCloseSelector(),

        // Display waktu yang dipilih
        _buildSelectedTimeDisplay(),

        SizedBox(height: 8),

        // Informasi tambahan
        Card(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Informasi Jam Operasional',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '• Pilih hari dan jam operasional Anda\n'
                  '• Jam tutup harus setelah jam buka\n'
                  '• Ini akan ditampilkan di profil Anda',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profil MUA"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Foto Profil Preview
                    Center(
                      child: Column(
                        children: [
                          _buildPhotoPreview(),
                          SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: _pickProfilePhoto,
                            icon: Icon(Icons.camera_alt),
                            label: Text(
                              profilePhoto == null
                                  ? "Pilih Foto Profil"
                                  : "Ganti Foto Profil",
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Form Fields
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Nama",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Nama harus diisi" : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: "No Telepon",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value!.isEmpty ? "No telepon harus diisi" : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: categoryController,
                      decoration: InputDecoration(
                        labelText: "Kategori",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Kategori harus diisi" : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: "Deskripsi",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: "Deskripsi",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: linkMapController,
                      decoration: InputDecoration(
                        labelText: "Link Map (Google Maps)",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.map),
                      ),
                      keyboardType: TextInputType.url,
                    ),
                    SizedBox(height: 20),

                    // Jam Operasional Section
                    _buildOperationalHoursSection(),

                    // Galeri Foto
                    OutlinedButton.icon(
                      onPressed: _pickGalleryPhotos,
                      icon: Icon(Icons.photo_library),
                      label: Text(
                        photos.isEmpty
                            ? "Pilih Foto Galeri"
                            : "Tambah Foto Galeri",
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Galeri Preview
                    _buildGalleryPreview(),

                    // Tombol Update
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoading ? null : updateProfile,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text("Menyimpan..."),
                              ],
                            )
                          : Text(
                              "Update Profil",
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
