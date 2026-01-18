import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';

final providerInboxProvider = StreamProvider<List<QueryDocumentSnapshot<Map<String, dynamic>>>>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return const Stream.empty();
  final fs = ref.read(firestoreServiceProvider);
  return fs.requests().where('providerCandidates', arrayContains: uid).snapshots().map((s) => s.docs);
});

class ProviderDashboardScreen extends ConsumerWidget {
  const ProviderDashboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availability = ref.watch(availabilityControllerProvider);
    final inbox = ref.watch(providerInboxProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Column(children: [
        SwitchListTile(title: const Text('Available'), value: availability, onChanged: (v) => ref.read(availabilityControllerProvider.notifier).setAvailability(v)),
        Expanded(child: inbox.when(
          data: (list) => ListView(children: list.map((r) => ListTile(title: Text('${r.data()['category']} ${r.data()['urgency']}'), subtitle: Text(r.data()['status']), trailing: ElevatedButton(onPressed: () async { await FirebaseFunctions.instance.httpsCallable('acceptRequest').call({'requestId': r.id}); }, child: const Text('Accept')))).toList()),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => const Center(child: Text('Error')),
        ))
      ]),
    );
  }
}
