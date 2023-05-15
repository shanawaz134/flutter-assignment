import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_assignment/components/constants.dart';
import 'package:flutter_assignment/login.dart';

class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorText = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorText = 'Wrong password provided for that user.';
      }
      // Handle other exceptions as needed
      return null;
    }
  }

  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorText = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorText = 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> addData(Map<String, dynamic> data) async {
    String collection = user!.email;
    await _fireStore.collection(collection).add(data);
  }

  Future<List<Map<String, dynamic>>> getData() async {
    String collection = user!.email;
    final QuerySnapshot snapshot = await _fireStore.collection(collection).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> deleteData(String id) async {
    String collection = user!.email;
    await _fireStore.collection(collection).doc(id).delete();
  }
}