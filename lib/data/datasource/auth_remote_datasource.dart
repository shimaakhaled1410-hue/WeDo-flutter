import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> login(String email, String password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user!.uid;

    final docSnapshot = await firestore.collection('users').doc(uid).get();

    if (docSnapshot.exists && docSnapshot.data() != null) {
      return UserModel.fromMap(docSnapshot.data()!, uid);
    } else {
      throw Exception("User data not found in database.");
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await userCredential.user?.updateDisplayName(name);
    await userCredential.user?.reload();
    
    final uid = userCredential.user!.uid;

    final userModel = UserModel(uid: uid, email: email, name: name, photoUrl: userCredential.user?.photoURL ?? '');

    await firestore.collection('users').doc(uid).set(userModel.toMap());

    return userModel;
  }

  @override
  Future<void> signOut() async => await firebaseAuth.signOut();
}
