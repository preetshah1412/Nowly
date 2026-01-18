import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Placeholder
            const Icon(
              Icons.emergency_share,
              size: 80,
              color: Colors.white,
            ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 20),

            Text(
              'ELSF',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
            ).animate().fadeIn(delay: 300.ms).moveY(begin: 20, end: 0),

            Text(
              'Emergency Local Services',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                  ),
            ).animate().fadeIn(delay: 500.ms),
          ],
        ),
      ),
    );
  }
}
