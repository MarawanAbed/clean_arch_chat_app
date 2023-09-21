import 'package:clean_arch_chat/Chat/domain/entities/message_entity.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {super.key,
        required this.messageModel,
        required this.isMe,
        });

  final MessageEntity messageModel;
  final bool isMe;


  @override
  Widget build(BuildContext context) {
    final isImageMessage = messageModel.chatContent.startsWith('http'); // Check if the content is a URL

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Align(
        alignment: isMe ? Alignment.topLeft : Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.red[300] : Colors.blue[300],
            borderRadius: isMe
                ? const BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            )
                : const BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
          ),
          margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment:
            isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              if (isImageMessage)
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(messageModel.chatContent),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Text(
                  messageModel.chatContent,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              const SizedBox(
                height: 5,
              ),
              Text(
                timeago.format(messageModel.chatSendTime),
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

