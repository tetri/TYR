import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:tyr/Pages/profile.dart';
import 'package:tyr/Pages/tasks.dart';
import '../Pages/home.dart';
import '../Pages/login_page.dart';

class Appdraw extends StatefulWidget {
  const Appdraw({super.key});

  @override
  State<Appdraw> createState() => _AppdrawState();
}

class _AppdrawState extends State<Appdraw> {
  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      username = prefs.getString('username') ?? 'User';
      email = user?.email ?? '';
    });
  }

  void signOut() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove('email');
    pref.remove('rememberMe');
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Drawer(
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0.8),
        child: Column(
          children: [
            // Drawer Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 80, bottom: 40, left: 32, right: 32),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TYR',
                    style: GoogleFonts.fraunces(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    username,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    email,
                    style: GoogleFonts.outfit(
                      color: Colors.white38,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                children: [
                  _buildNavItem(Icons.home_outlined, 'Home',
                      () => _navigate(const Home())),
                  _buildNavItem(Icons.person_outline_rounded, 'Profile',
                      () => _navigate(const CurrentUser())),
                  _buildNavItem(Icons.checklist_rounded, 'Your Tasks',
                      () => _navigate(const TaskScreen())),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(
                        color: Colors.white10, indent: 16, endIndent: 16),
                  ),
                  _buildNavItem(Icons.info_outline_rounded, 'About', () {}),
                ],
              ),
            ),

            // Logout
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: _buildNavItem(Icons.logout_rounded, 'Logout', signOut,
                  color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }

  void _navigate(Widget page) {
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  Widget _buildNavItem(IconData icon, String title, VoidCallback onTap,
      {Color color = Colors.white}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon,
          color: color.withOpacity(color == Colors.white ? 0.7 : 1), size: 24),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          color: color,
          fontSize: 18,
          fontWeight:
              color == Colors.redAccent ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
