import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> users() => _db.collection('users');
  CollectionReference<Map<String, dynamic>> providers() => _db.collection('providers');
  CollectionReference<Map<String, dynamic>> requests() => _db.collection('service_requests');
  CollectionReference<Map<String, dynamic>> jobHistory() => _db.collection('job_history');
}
