import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tyr/Pages/create_task.dart';
import 'package:tyr/components/app_drawer.dart';
import 'package:tyr/components/card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyr/logger.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String username = '';

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  Future<void> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
    });
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
          'TYR',
          style: GoogleFonts.fraunces(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Track Your Routine',
                  style: GoogleFonts.fraunces(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Welcome back, $username!',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Your Feed',
                  style: GoogleFonts.fraunces(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      TheCard(
                        onTap: () => appLogger.info('Card 1 clicked'),
                        imageLink:
                            'https://images.unsplash.com/photo-1603518784337-07df4f1895e8?auto=format&fit=crop&w=1470&q=80',
                        description:
                            'Boost productivity with TYR: The ultimate app to track your routine.',
                      ),
                      const SizedBox(width: 16),
                      TheCard(
                        onTap: () => appLogger.info('Card 2 clicked'),
                        imageLink:
                            'https://images.unsplash.com/photo-1603518784337-07df4f1895e8?auto=format&fit=crop&w=1470&q=80',
                        description:
                            'Stay organized and achieve your goals effortlessly.',
                      ),
                      const SizedBox(width: 16),
                      TheCard(
                        onTap: () => appLogger.info('Card 3 clicked'),
                        imageLink:
                            'https://images.unsplash.com/photo-1603518784337-07df4f1895e8?auto=format&fit=crop&w=1470&q=80',
                        description:
                            'Manage your time like a pro with our smart features.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'New Task',
                  style: GoogleFonts.fraunces(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const CreateTask()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.add_rounded,
                            color: Colors.white, size: 40),
                        const SizedBox(height: 12),
                        Text(
                          'Create New Task',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
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
}
