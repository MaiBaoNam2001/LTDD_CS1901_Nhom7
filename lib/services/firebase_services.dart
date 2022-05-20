import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServives {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  String getUserId() {
    return firebaseAuth.currentUser!.uid;
  }

  final CollectionReference productsReference =
      FirebaseFirestore.instance.collection("Products");

  final CollectionReference usersReference =
      FirebaseFirestore.instance.collection("Users");
}
