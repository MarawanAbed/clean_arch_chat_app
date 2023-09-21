
import 'package:clean_arch_chat/utils/common/common.dart';

class MessageEntity {
  final String chatSenderId;
  final String chatReceiverId;
  final String chatContent;
  final DateTime chatSendTime;
  final MessageType chatMessageType;

  MessageEntity({
    required this.chatSenderId,
    required this.chatReceiverId,
    required this.chatContent,
    required this.chatSendTime,
    required this.chatMessageType,
  });
}

