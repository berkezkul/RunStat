import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoalService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> saveGoal(double goalDistance, double completedDistance,
      double percentage) async {
    User? user = _auth.currentUser;

    await _firestore
        .collection('users')
        .doc(user?.uid)
        .collection('goals')
        .doc('today')
        .set({
      'date': Timestamp.now(),
      'goalDistance': goalDistance,
      'completedDistance': completedDistance,
      'percentage': percentage,
    });
  }

  Future<double> getDailyDistance() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("Kullanıcı oturum açmamış!");
    }

    String? userId = user?.uid;

    // Günün başlangıcı ve bitişini Timestamp olarak hesapla
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('runs')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .get();

    print("Bulunan döküman sayısı: ${querySnapshot.docs.length}");


    double totalDistance = 0.0;
    for (var doc in querySnapshot.docs) {
      print("Bulunan doküman: ${doc.data()}");
      totalDistance += doc['distance'];
    }

    return totalDistance;
  }

  Future<double> getGoalDistance() async {
    User? user = _auth.currentUser;
    DocumentSnapshot doc = await _firestore
        .collection('users')
        .doc(user?.uid)
        .collection('goals')
        .doc('today')
        .get();

    if (doc.exists) {
      return doc['goalDistance']?.toDouble() ?? 0.0; // Eğer yoksa 0.0 döner
    }
    return 0.0; // Eğer hiç kaydedilmemişse 0.0 döner
  }

}