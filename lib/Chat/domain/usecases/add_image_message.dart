import 'dart:io';

import 'package:clean_arch_chat/Chat/domain/repo/repo.dart';

class AddImageMessageUseCase
{
  final HomeRepo repo;

  AddImageMessageUseCase(this.repo);

Future<void> call(String receiverId, File imageFile) async {
    return await repo.addImageMessage(receiverId, imageFile);
  }
}