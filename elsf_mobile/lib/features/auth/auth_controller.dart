import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/providers.dart';

class AuthState {
  final User? user;
  final String? verificationId;
  AuthState({this.user, this.verificationId});
  AuthState copyWith({User? user, String? verificationId}) => AuthState(user: user ?? this.user, verificationId: verificationId ?? this.verificationId);
}

class AuthController extends StateNotifier<AuthState> {
  final Ref ref;
  AuthController(this.ref) : super(AuthState()) {
    ref.read(authServiceProvider).authStateChanges().listen((u) => state = state.copyWith(user: u));
  }
  Future<void> startPhoneSignIn(String phone) async {
    await ref.read(authServiceProvider).signInWithPhone(phone, onCodeSent: (id) => state = state.copyWith(verificationId: id));
  }
  Future<void> confirmCode(String code) async {
    final id = state.verificationId;
    if (id == null) return;
    await ref.read(authServiceProvider).confirmCode(id, code);
    state = state.copyWith(verificationId: null);
  }
  Future<void> signOut() async {
    await ref.read(authServiceProvider).signOut();
  }
}
