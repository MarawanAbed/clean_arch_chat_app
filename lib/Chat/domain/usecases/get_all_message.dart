import 'package:clean_arch_chat/Chat/domain/entities/message_entity.dart';
import 'package:clean_arch_chat/Chat/domain/repo/repo.dart';

class GetAllMessagesUseCase
{
  final HomeRepo repo;

  GetAllMessagesUseCase(this.repo);

  Stream<List<MessageEntity>> call(String receiverId) => repo.getAllMessages(receiverId);
}