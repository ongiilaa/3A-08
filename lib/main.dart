import 'package:coffeshop/profile_page.dart';
import 'package:coffeshop/welcome_page.dart';
import 'package:coffeshop/cart_page.dart';
import 'package:flutter/material.dart';

import 'favorit_page.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'sign_up2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kopi Sruput',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFFFF8E6)),
      home: const WelcomePage(),
      routes: {
        "/login": (context) => const LoginPage(),
        "/signup": (context) => const SignUpStep2(),
        "/home": (context) => const HomePage(),
        "/cart": (context) => const CartPage(),
        "/favorite": (context) => const FavoritePage(),
        "/profile": (context) => const ProfilePage(),
      },
    );
  }
}
