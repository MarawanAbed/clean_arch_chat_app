import 'dart:async';
import 'dart:io';

import 'package:clean_arch_chat/auth/data/models/user_model.dart';
import 'package:clean_arch_chat/auth/data/source/remote_data_source/remote_data_source.dart';
import 'package:clean_arch_chat/auth/domain/entities/user_entity.dart';
import 'package:clean_arch_chat/utils/services/notification_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;
  Timer? emailVerificationTimer;
  AuthRemoteDataSourceImpl({required this.fireStore, required this.auth});
  static final notification = NotificationServices();
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
    await notification.requestPermission();
    await notification.getToken();
  }

  @override
  Future signIn(UserEntity userEntity) async {
    await auth.signInWithEmailAndPassword(
      email: userEntity.userEmail!,
      password: userEntity.userPassword!,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'isOnline': true, 'lastActive': DateTime.now()});
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
  Future signOut() async {
    return await auth.signOut();
  }

  @override
  Future<String> uploadImage(File imageFile) async {
    try {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().millisecondsSinceEpoch}');
      final UploadTask uploadTask = storageReference.putFile(imageFile);
      final TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null);
      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Image upload error: $e');
      throw Exception('Failed to upload image');
    }
  }
}
