import 'dart:io';

import 'package:clean_arch_chat/Chat/data/source/data_source/data_source.dart';
import 'package:clean_arch_chat/Chat/domain/entities/message_entity.dart';
import 'package:clean_arch_chat/Chat/domain/repo/repo.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeDataSource dataSource;

  HomeRepoImpl(this.dataSource);

  @override
  Future getAllUser() async {
    return await dataSource.getAllUser();
  }

  @override
  Future signOut() async {
    return await dataSource.signOut();
  }

  @override
  Future updateUser(Map<String, dynamic> data) async {
    return await dataSource.updateUser(data);
  }

  @override
  Future getSingleUser(String uId) async {
    return await dataSource.getSingleUser(uId);
  }

  @override
  Future currentUserId() async {
    return await dataSource.currentUserId();
  }

  @override
  Future<String> uploadProfileImage(File imageFile) async {
    return await dataSource.uploadProfileImage(imageFile);
  }

  @override
  Future addTextMessage(MessageEntity messageEntity) async {
    return await dataSource.addTextMessage(messageEntity);
  }

  @override
  Future addImageMessage(String receiverId, File imageFile) {
    return dataSource.addImageMessage(receiverId, imageFile);
  }

  @override
  Stream<List<MessageEntity>> getAllMessages(String receiverId) {
    return dataSource.getAllMessages(receiverId);
  }

  @override
  searchUser(String userName) async {
    return await dataSource.searchUser(userName);
  }
}
