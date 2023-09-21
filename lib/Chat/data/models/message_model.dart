import 'package:clean_arch_chat/Chat/domain/entities/message_entity.dart';
import 'package:clean_arch_chat/utils/common/common.dart';

class MessageModel extends MessageEntity {
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime sendTime;
  final MessageType messageType;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.sendTime,
    required this.messageType,
  }) : super(
            chatSenderId: senderId,
            chatReceiverId: receiverId,
            chatContent: content,
            chatSendTime: sendTime,
            chatMessageType: messageType,
  );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json["senderId"],
      receiverId: json["receiverId"],
      content: json["content"],
      sendTime: json["sendTime"].toDate(),
      messageType: getMessageTypeFromString(json["messageType"]),
    );
  }

  //create tomap
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'sendTime': sendTime,
      'messageType': messageType.name,
    };
  }
}




