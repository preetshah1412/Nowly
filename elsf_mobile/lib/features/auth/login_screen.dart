import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../core/router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _code = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone'), keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => ref.read(authControllerProvider.notifier).startPhoneSignIn(_phone.text), child: const Text('Send Code')),
            const SizedBox(height: 12),
            TextField(controller: _code, decoration: const InputDecoration(labelText: 'Code')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => ref.read(authControllerProvider.notifier).confirmCode(_code.text), child: const Text('Confirm')),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.serviceSelection), child: const Text('Continue'))
          ],
        ),
      ),
    );
  }
}
