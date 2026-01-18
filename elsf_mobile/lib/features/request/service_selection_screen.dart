import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../core/router.dart';

class ServiceSelectionScreen extends ConsumerWidget {
  const ServiceSelectionScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ['plumber', 'electrician', 'mechanic'];
    return Scaffold(
      appBar: AppBar(title: const Text('Select Service')),
      body: ListView(children: categories.map((c) => ListTile(title: Text(c), onTap: () { ref.read(requestControllerProvider.notifier).setCategory(c); Navigator.pushNamed(context, AppRoutes.urgency); })).toList()),
    );
  }
}
