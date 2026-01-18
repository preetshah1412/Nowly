import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/providers.dart';

class RequestState {
  final String? category;
  final String? urgency;
  final LatLng? location;
  final String? activeRequestId;
  RequestState({this.category, this.urgency, this.location, this.activeRequestId});
  RequestState copyWith({String? category, String? urgency, LatLng? location, String? activeRequestId}) =>
      RequestState(category: category ?? this.category, urgency: urgency ?? this.urgency, location: location ?? this.location, activeRequestId: activeRequestId ?? this.activeRequestId);
}

class RequestController extends StateNotifier<RequestState> {
  final Ref ref;
  RequestController(this.ref) : super(RequestState());
  void setCategory(String v) => state = state.copyWith(category: v);
  void setUrgency(String v) => state = state.copyWith(urgency: v);
  void setLocation(LatLng p) => state = state.copyWith(location: p);
  Future<void> submit() async {
    final u = ref.read(authControllerProvider).user;
    final s = state;
    if (u == null || s.category == null || s.urgency == null || s.location == null) return;
    final expiresMinutes = s.urgency == 'immediate' ? 45 : s.urgency == 'same_day' ? 240 : 1440;
    final data = {
      'userId': u.uid,
      'category': s.category,
      'urgency': s.urgency,
      'location': GeoPoint(s.location!.latitude, s.location!.longitude),
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(DateTime.now().toUtc().add(Duration(minutes: expiresMinutes))),
    };
    final doc = await ref.read(firestoreServiceProvider).requests().add(data);
    state = state.copyWith(activeRequestId: doc.id);
  }
}
