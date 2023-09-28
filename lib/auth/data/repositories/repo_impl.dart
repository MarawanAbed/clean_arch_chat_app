import 'dart:io';

import 'package:clean_arch_chat/auth/data/source/remote_data_source/remote_data_source.dart';
import 'package:clean_arch_chat/auth/domain/entities/user_entity.dart';
import 'package:clean_arch_chat/auth/domain/repositories/repo.dart';
import 'package:clean_arch_chat/utils/services/show_snack_message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepoImpl(this._remoteDataSource);

  @override
  Future createUser(UserEntity userEntity) async {
    return await _remoteDataSource.createUser(userEntity);
  }

  @override
  Future currentUserId() async {
    return await _remoteDataSource.currentUserId();
  }

  @override
  Future forgetPassword(String email) async {
    return await _remoteDataSource.forgetPassword(email);
  }

  @override
  Future signIn(UserEntity userEntity) async {
    try {
      return await _remoteDataSource.signIn(userEntity);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Utils.showSnackBar('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Utils.showSnackBar('Wrong password provided for that user.');
      }
    }
  }

  @override
  Future signUp(UserEntity userEntity) async {
    try {
       return await _remoteDataSource.signUp(userEntity);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Utils.showSnackBar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Utils.showSnackBar('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future sendVerificationEmail() async {
    return await _remoteDataSource.sendVerificationEmail();
  }

  @override
  Future isEmailVerified() async {
    return await _remoteDataSource.isEmailVerified();
  }

  @override
  Future signOut() async {
    return await _remoteDataSource.signOut();
  }

  @override
  Future<String> uploadImage(File imageFile) async {
    return await _remoteDataSource.uploadImage(imageFile);
  }
}
