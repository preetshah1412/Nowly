import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/fcm_service.dart';
import '../services/location_service.dart';
import '../features/auth/auth_controller.dart';
import '../features/request/request_controller.dart';
import '../features/provider/availability_controller.dart';

final firebaseInitProvider = FutureProvider<FirebaseApp>((ref) async {
  return Firebase.initializeApp();
});

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());
final fcmServiceProvider = Provider<FcmService>((ref) => const FcmService());
final locationServiceProvider = Provider<LocationService>((ref) => LocationService());

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) => AuthController(ref));
final requestControllerProvider = StateNotifierProvider<RequestController, RequestState>((ref) => RequestController(ref));
final availabilityControllerProvider = StateNotifierProvider<AvailabilityController, bool>((ref) => AvailabilityController(ref));
