import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Premium Animated Background
          Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
            ),
          ).animate().fadeIn(duration: 800.ms),

          // 2. Decorative Background Circles
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ).animate().scale(duration: 2.seconds, curve: Curves.easeInOut),
          ),

          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          // 3. Main Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo & Header
                  const Icon(
                    Icons.security_rounded,
                    size: 64,
                    color: Colors.white,
                  )
                      .animate()
                      .scale(duration: 600.ms, curve: Curves.elasticOut)
                      .then()
                      .shimmer(duration: 2.seconds, delay: 1.seconds),

                  const SizedBox(height: 24),

                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ).animate().fadeIn().moveY(begin: 30, end: 0),

                  const SizedBox(height: 8),

                  Text(
                    'Secure access to emergency services',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 48),

                  // 4. Glassmorphism Login Card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Phone Input
                            TextFormField(
                              controller: _phoneController,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                labelStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.8)),
                                prefixIcon: Icon(Icons.phone_iphone_rounded,
                                    color: Colors.white.withOpacity(0.8)),
                                prefixText: '+91 ',
                                prefixStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.1)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1.5),
                                ),
                              ),
                            ).animate().fadeIn(delay: 400.ms).moveX(begin: -20),

                            const SizedBox(height: 24),

                            // Continue Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_phoneController.text.length == 10) {
                                    // Navigate to Home
                                    context.go('/home');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Please enter a valid 10-digit number'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppTheme.primary,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  elevation: 0,
                                ),
                                child: const Text('Continue'),
                              ),
                            ).animate().fadeIn(delay: 600.ms).moveY(begin: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Footer
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'I want to register as a Service Provider',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ).animate().fadeIn(delay: 800.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
