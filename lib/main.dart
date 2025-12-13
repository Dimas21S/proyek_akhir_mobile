import 'package:proyek_akhir/pages/admin/admin_verification.dart';
import 'package:proyek_akhir/pages/artist/artist_beranda.dart';
import 'package:proyek_akhir/pages/artist/artist_chat.dart';
import 'package:proyek_akhir/pages/artist/edit_profil.dart';
import 'package:proyek_akhir/pages/artist/submit_request.dart';
import 'package:proyek_akhir/pages/auth/artist_login.dart';
import 'package:proyek_akhir/pages/auth/artist_register.dart';
import 'package:proyek_akhir/pages/auth/register.dart';
import 'package:proyek_akhir/pages/chat/artist_to_user.dart';
import 'package:proyek_akhir/pages/chat/user_to_artist.dart';
import 'package:proyek_akhir/pages/contact_us.dart';
import 'package:proyek_akhir/pages/auth/login.dart';
import 'package:proyek_akhir/pages/user/user_booking.dart';
import 'package:proyek_akhir/pages/user/user_favorite.dart';
import 'package:proyek_akhir/pages/user/user_find_location.dart';
import 'package:proyek_akhir/pages/user/user_home.dart';
import 'package:proyek_akhir/pages/user/user_profile.dart';
import 'package:proyek_akhir/pages/user/user_to_description.dart';
import 'package:flutter/material.dart';
import 'pages/about_us.dart';
import 'pages/landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      home: ArtistLoginPage(),

      routes: {
        '/about': (context) => const AboutUsPage(),
        '/contact': (context) => const ContactUsPage(),

        // Autentikasi
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        // '/login-mua': (context) => const ArtistLoginPage(),
        '/register-mua': (context) => const ArtistRegisterPage(),

        //User
        '/profil': (context) => const UserProfile(),
        '/lokasi': (context) => const UserFindLocation(),
        '/favorit': (context) => const UserFavorite(),
        '/deskripsi-artist': (context) => UserToDescription(),
        '/beranda': (context) => const UserHome(),
        '/booking': (context) => const UserBooking(),

        // Khusus Chat
        '/user-to-artist': (context) => const UserToArtist(),
        '/artist-to-user': (context) => ArtistToUser(),

        // Admin
        '/admin-home': (context) => const AdminVerification(),

        // Make Up Artist
        '/beranda-mua': (context) => const ArtistBeranda(),
        '/chat-mua': (context) => const ArtistChat(),
        '/submit-request': (context) => const SubmitRequest(),
        '/edit-profil-mua': (context) => const EditProfil(),
      },
    );
  }
}
