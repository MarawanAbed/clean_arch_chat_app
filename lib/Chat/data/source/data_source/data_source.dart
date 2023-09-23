import 'dart:io';

import 'package:clean_arch_chat/Chat/domain/entities/message_entity.dart';

abstract class HomeDataSource {
  Future<dynamic> getAllUser();
  Future<dynamic> getSingleUser(String uId);
  Future<dynamic> signOut();
  Future<dynamic> updateUser(Map<String,dynamic>data);
  Future<dynamic> currentUserId();
  Future<String> uploadProfileImage(File imageFile);
  Future<dynamic>addTextMessage(MessageEntity messageEntity);
  Future<dynamic>addImageMessage(String receiverId, File imageFile);
  Stream<List<MessageEntity>>getAllMessages(String receiverId);
  searchUser(String userName);

}