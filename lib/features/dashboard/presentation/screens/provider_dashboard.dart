import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class ProviderDashboardScreen extends ConsumerWidget {
  const ProviderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock Availability State
    // ignore: unused_local_variable
    final bool isAvailable = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Dashboard'),
        actions: [
          Switch(
            value: isAvailable,
            onChanged: (val) {
              // Toggle Availability
            },
            activeThumbColor: AppTheme.success,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isAvailable ? AppTheme.success : Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    isAvailable ? Icons.check_circle : Icons.do_not_disturb_on,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAvailable ? 'You are Online' : 'You are Offline',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Receiving jobs...',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Text('Active Requests',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),

            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.radar, size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(
                      'Scanning area...',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
