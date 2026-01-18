import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../core/router.dart';

class UrgencyScreen extends ConsumerWidget {
  const UrgencyScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Urgency')),
      body: Column(children: [
        ListTile(title: const Text('Immediate'), onTap: () { ref.read(requestControllerProvider.notifier).setUrgency('immediate'); Navigator.pushNamed(context, AppRoutes.mapView); }),
        ListTile(title: const Text('Same Day'), onTap: () { ref.read(requestControllerProvider.notifier).setUrgency('same_day'); Navigator.pushNamed(context, AppRoutes.mapView); }),
        ListTile(title: const Text('Scheduled'), onTap: () { ref.read(requestControllerProvider.notifier).setUrgency('scheduled'); Navigator.pushNamed(context, AppRoutes.mapView); }),
      ]),
    );
  }
}
