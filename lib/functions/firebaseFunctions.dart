import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static saveUser(
      {String? name,
      String? email,
      String? phone,
      String? gender,
      String? fcm,
      String? uid}) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'name': name,
      'gender': gender,
      'fcm': fcm,
      'phone_number': phone,
    });
  }

  static updateUser({String? fcm, String? uid}) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'fcm': fcm,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFirebaseUser() {
    User? user = _auth.currentUser;
    var subscription = _firestore
        .collection('users')
        .where('email', isNotEqualTo: user?.email)
        .snapshots();
    print(subscription);
    return subscription;
  }
}
