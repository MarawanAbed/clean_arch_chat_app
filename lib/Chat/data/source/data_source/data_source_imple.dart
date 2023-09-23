import 'dart:io';

import 'package:clean_arch_chat/Chat/data/models/message_model.dart';
import 'package:clean_arch_chat/Chat/data/models/user_model.dart';
import 'package:clean_arch_chat/Chat/data/source/data_source/data_source.dart';
import 'package:clean_arch_chat/Chat/domain/entities/message_entity.dart';
import 'package:clean_arch_chat/Chat/domain/entities/user_entity.dart';
import 'package:clean_arch_chat/utils/common/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomeDataSourceImpl implements HomeDataSource {
  final FirebaseFirestore firebaseStore;
  final FirebaseAuth firebaseAuth;

  HomeDataSourceImpl({required this.firebaseStore, required this.firebaseAuth});

  @override
  Future getAllUser() async {
    final userCollection = firebaseStore
        .collection('users')
        .orderBy('lastActive', descending: true);
    return userCollection.snapshots(includeMetadataChanges: true).map(
            (querySnapshot) =>
            querySnapshot.docs
                .map((e) => UserModel.fromJson(e.data()))
                .toList());
  }

  @override
  Future signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future updateUser(UserEntity user) async {
    Map<String, dynamic> userMap = {};
    final userCollection = firebaseStore.collection('users');
    if (user.userUId != null && user.userUId!.isNotEmpty) {
      userMap['uId'] = user.userUId;
    }
    if (user.userImage != null && user.userImage!.isNotEmpty) {
      userMap['image'] = user.userImage;
    }
    if (user.userName != null && user.userName!.isNotEmpty) {
      userMap['name'] = user.userName;
    }
    if (user.userEmail != null && user.userEmail!.isNotEmpty) {
      userMap['email'] = user.userEmail;
    }
    if (user.userPassword != null && user.userPassword!.isNotEmpty) {
      userMap['password'] = user.userPassword;
    }
    userMap['lastActive'] = DateTime.now();
    userMap['isOnline'] = true;
    userCollection.doc(user.userUId).update(userMap);
  }

  @override
  Future currentUserId() async {
    return firebaseAuth.currentUser!.uid;
  }

  @override
  Future getSingleUser(String uId) async {
    final uId = await currentUserId();
    final userDoc = firebaseStore.collection('users').doc(uId);
    final userSnapshot = await userDoc.get();

    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      return UserModel.fromJson(userData);
    } else {
      return null; // User not found
    }
  }

  @override
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      final uId = await currentUserId();
      final Reference storageReference = FirebaseStorage.instance.ref().child(
          'profile_images/$uId/${DateTime
              .now()
              .millisecondsSinceEpoch}');
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

  @override
  Future addTextMessage(MessageEntity messageEntity) async {
    final uId = await currentUserId();
    //set my chat
    final message = MessageModel(
      senderId: uId,
      receiverId: messageEntity.chatReceiverId,
      content: messageEntity.chatContent,
      sendTime: DateTime.now(),
      messageType: MessageType.text,
    ).toMap();
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(messageEntity.chatReceiverId)
        .collection('messages')
        .add(message);
    //set receiver chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(messageEntity.chatReceiverId)
        .collection('chats')
        .doc(uId)
        .collection('messages')
        .add(message);
  }

  @override
  Future<String> addImageMessage(String receiverId, File imageFile) async {
    try {
      final uId = await currentUserId();
      final imageUrl = await uploadProfileImage(imageFile);

      // Create a message with the image URL
      final message = MessageModel(
        senderId: uId,
        receiverId: receiverId,
        content: imageUrl,
        sendTime: DateTime.now(),
        messageType: MessageType.image,
      ).toMap();

      // Store the message in the my chat
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .add(message);
      //store the message in the receiver chat
      FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(uId)
          .collection('messages')
          .add(message);

      return imageUrl;
    } catch (e) {
      print('Image upload error: $e');
      throw Exception('Failed to upload image');
    }
  }

  @override
  Stream<List<MessageEntity>> getAllMessages(String receiverId) async* {
    final uId = await currentUserId();
    final messageCollection = firebaseStore
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('sendTime', descending: false)
        .snapshots();

    await for (QuerySnapshot querySnapshot in messageCollection) {
      final List<MessageEntity> messages = querySnapshot.docs
          .map((doc) => MessageModel.fromJson(doc.data()))
          .toList();

      yield messages;
    }
  }

}
