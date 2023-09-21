import 'package:clean_arch_chat/Chat/domain/entities/message_entity.dart';
import 'package:clean_arch_chat/Chat/presentation/manager/chat/chat_cubit.dart';
import 'package:clean_arch_chat/utils/common/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({super.key, required this.receiverId});

  final String receiverId;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  var messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        var cubit = ChatCubit.get(context);
        return Row(
          children: [
            Expanded(
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                _sendText(context);
              },
              child: const Icon(Icons.send),
            ),
            const SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {
                cubit.pickAndSendImage(widget.receiverId);
              },
              child: const Icon(Icons.camera_alt_outlined),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendText(context) async {
    final messageContent = messageController.text.trim();
    if (messageContent.isNotEmpty) {
      await ChatCubit.get(context).addTextMessage(
        MessageEntity(
          chatSenderId: FirebaseAuth.instance.currentUser!.uid,
          chatReceiverId: widget.receiverId,
          chatContent: messageContent,
          chatSendTime: DateTime.now(),
          chatMessageType: MessageType.text,
        ),
      );
      messageController.clear();
      FocusScope.of(context).unfocus();
    }
  }
}
