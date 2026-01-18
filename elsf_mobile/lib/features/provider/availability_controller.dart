import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvailabilityController extends StateNotifier<bool> {
  final Ref ref;
  AvailabilityController(this.ref) : super(false);
  Future<void> setAvailability(bool v) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await ref.read(firestoreServiceProvider).providers().doc(uid).set({'availability': v}, SetOptions(merge: true));
    state = v;
  }
}
