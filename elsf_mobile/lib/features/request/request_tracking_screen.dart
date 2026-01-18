import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/providers.dart';

final requestStreamProvider = StreamProvider.family<DocumentSnapshot<Map<String, dynamic>>?, String>((ref, id) {
  return ref.read(firestoreServiceProvider).requests().doc(id).snapshots();
});

class RequestTrackingScreen extends ConsumerWidget {
  final String requestId;
  const RequestTrackingScreen({super.key, required this.requestId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final req = ref.watch(requestStreamProvider(requestId));
    return Scaffold(
      appBar: AppBar(title: const Text('Tracking')),
      body: req.when(
        data: (d) {
          if (d == null || !d.exists) return const Center(child: Text('Not found'));
          final data = d.data()!;
          return Column(children: [
            Text('Status: ${data['status']}'),
            if (data['acceptedBy'] != null) Text('Provider: ${data['acceptedBy']}')
          ]);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => const Center(child: Text('Error')),
      ),
    );
  }
}
