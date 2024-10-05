import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RunService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveRunData(Map<String, dynamic> runData) async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Kullanıcının UID'si altında koşu verilerini kaydetme
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('runs')
          .add(runData);
    }
  }

  Future<List<Map<String, dynamic>>> getUserRuns() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Kullanıcının UID'si altında koşu verilerini alma
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('runs')
          .get();

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    }
    return [];
  }
}
