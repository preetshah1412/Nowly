import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> authStateChanges() => _auth.authStateChanges();
  Future<void> signInWithPhone(String phone, {required Function(String verificationId) onCodeSent}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (e) {},
      codeSent: (verificationId, forceResendingToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }
  Future<void> confirmCode(String verificationId, String smsCode) async {
    final credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    await _auth.signInWithCredential(credential);
  }
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
