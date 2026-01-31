import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyr/Pages/home.dart';
import 'package:tyr/Pages/login_page.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    final pref = await SharedPreferences.getInstance();
    bool remember = pref.getBool('rememberMe') ?? false;
    if (remember) {
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } else {
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
