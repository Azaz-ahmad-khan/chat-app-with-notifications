//lib\core\services\auth_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noti_chat/core/services/notification_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<UserCredential?> signUpwithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> saveUserToFirestore(
    String name,
    String email,
    String password,
  ) async {
    try {
      UserCredential? uCredential = await signUpwithEmail(email, password);
      if (uCredential == null) throw Exception('User Not created');
      await firebaseFirestore
          .collection('Users')
          .doc(uCredential.user!.uid)
          .set({
            'email': uCredential.user!.email,
            'userId': uCredential.user!.uid,
            'name': name,
            'fcmToken': '',
          });
      await getToken(uCredential.user!.uid);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserCredential?> signInUser(String email, String password) async {
    try {
      UserCredential? user = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user.user != null) {
        await getToken(user.user!.uid);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOUt() async {
    await firebaseAuth.signOut();
  }

  Stream<List<Map<String, dynamic>>> getUsers() {
    return firebaseFirestore.collection('Users').snapshots().map((snapShot) {
      return snapShot.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }

  Future<void> getToken(String user) async {
    final token = await NotificationService.instance.getToken();
    if (token == null) return;
    await firebaseFirestore.collection('Users').doc(user).update({
      'fcmToken': token,
    });
  }
}
