import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyr/Pages/login_page.dart';
import 'package:tyr/logger.dart';
import '../components/app_drawer.dart';

class CurrentUser extends StatefulWidget {
  const CurrentUser({super.key});

  @override
  State<CurrentUser> createState() => _CurrentUserState();
}

class _CurrentUserState extends State<CurrentUser> {
  final curPwd = TextEditingController();
  final newPwd = TextEditingController();
  final changUname = TextEditingController();

  String username = '';
  String? email;
  String? lastSignIn;
  String joinedDate = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    curPwd.dispose();
    newPwd.dispose();
    changUname.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username') ?? 'User';
      email = user?.email;
      if (user?.metadata.lastSignInTime != null) {
        lastSignIn = DateFormat('MMM dd, yyyy HH:mm')
            .format(user!.metadata.lastSignInTime!);
      }
      if (user?.metadata.creationTime != null) {
        joinedDate =
            DateFormat('MMMM dd, yyyy').format(user!.metadata.creationTime!);
      }
    });
  }

  Future<void> changePassword(
      {required String curPassword, required String newPassword}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) return;

    setState(() => isLoading = true);
    try {
      final cred = EmailAuthProvider.credential(
          email: user.email!, password: curPassword);
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully')),
        );
      }
    } catch (e) {
      appLogger.severe(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> changeUsername() async {
    if (changUname.text.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', changUname.text.trim());
    setState(() {
      username = changUname.text.trim();
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username updated successfully')),
      );
    }
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
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const Appdraw(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Profile',
          style: GoogleFonts.fraunces(
              color: Colors.white, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person_rounded,
                            size: 60, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        username,
                        style: GoogleFonts.fraunces(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        email ?? '',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Account Info Section
                _buildSectionHeader('ACCOUNT INFO'),
                _buildInfoCard([
                  _buildInfoRow('Joined', joinedDate),
                  _buildInfoRow('Last Sign In', lastSignIn ?? 'N/A'),
                ]),

                const SizedBox(height: 32),

                // Settings Section
                _buildSectionHeader('SETTINGS'),
                _buildActionTile(
                  icon: Icons.edit_rounded,
                  title: 'Update Username',
                  onTap: () => _showUpdateUsernameDialog(),
                ),
                const SizedBox(height: 12),
                _buildActionTile(
                  icon: Icons.lock_rounded,
                  title: 'Change Password',
                  onTap: () => _showChangePasswordDialog(),
                ),

                const SizedBox(height: 48),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: signOut,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side:
                            const BorderSide(color: Colors.redAccent, width: 1),
                      ),
                    ),
                    child: Text(
                      'LOGOUT',
                      style: GoogleFonts.outfit(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Colors.white38,
            letterSpacing: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14)),
          Text(value,
              style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildActionTile(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white24, size: 16),
          ],
        ),
      ),
    );
  }

  void _showUpdateUsernameDialog() {
    changUname.text = username;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Update Username',
            style: GoogleFonts.fraunces(color: Colors.white)),
        content: TextField(
          controller: changUname,
          style: const TextStyle(color: Colors.white),
          decoration: _dialogInputDecoration('New username'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[400]))),
          ElevatedButton(
            onPressed: () {
              changeUsername();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, foregroundColor: Colors.black),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    curPwd.clear();
    newPwd.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Change Password',
            style: GoogleFonts.fraunces(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: curPwd,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: _dialogInputDecoration('Current password'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPwd,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: _dialogInputDecoration('New password'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[400]))),
          ElevatedButton(
            onPressed: () {
              changePassword(
                  curPassword: curPwd.text, newPassword: newPwd.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, foregroundColor: Colors.black),
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  InputDecoration _dialogInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }
}
