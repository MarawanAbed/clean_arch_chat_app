import 'dart:async';

import 'package:clean_arch_chat/auth/data/models/user_model.dart';
import 'package:clean_arch_chat/auth/data/source/remote_data_source/remote_data_source.dart';
import 'package:clean_arch_chat/auth/domain/entities/user_entity.dart';
import 'package:clean_arch_chat/utils/services/show_snack_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;
  Timer? emailVerificationTimer;

  AuthRemoteDataSourceImpl({required this.fireStore, required this.auth});

  @override
  Future createUser(UserEntity userEntity) async {
    final userCollection = fireStore.collection('users');
    final uId = await currentUserId();

    userCollection.doc(uId).get().then((value) {
      final user = UserModel(
        uId: uId,
        name: userEntity.userName!,
        email: userEntity.userEmail!,
        password: userEntity.userPassword!,
        image: userEntity.userImage!,
        lastActive: DateTime.now(),
        isOnline: true,
      ).toJson();
      if (!value.exists) {
        userCollection.doc(uId).set(user);
      } else {
        return;
      }
    });
  }

  @override
  Future signIn(UserEntity userEntity) async {
    await auth.signInWithEmailAndPassword(
        email: userEntity.userEmail!, password: userEntity.userPassword!);
  }

  @override
  Future signUp(UserEntity userEntity) async {
    return await auth.createUserWithEmailAndPassword(
        email: userEntity.userEmail!, password: userEntity.userPassword!);
  }

  @override
  Future forgetPassword(String email) async {
    return await auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future currentUserId() async => auth.currentUser!.uid;


  @override
  Future<bool> isEmailVerified() async {
    final user = auth.currentUser!;
    await user.reload();
    return user.emailVerified;
  }

  @override
  Future<void> sendVerificationEmail() async {
    try {
      final user = auth.currentUser!;
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      } else {
        throw Exception('Email is already verified');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future signOut()async {
    return await auth.signOut();
  }



}
