import 'package:clean_arch_chat/Chat/domain/entities/user_entity.dart';
import 'package:clean_arch_chat/Chat/presentation/widgets/chat_message.dart';
import 'package:clean_arch_chat/Chat/presentation/widgets/chat_text_field.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.model}) : super(key: key);
  final UserEntity model;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.model.userImage!),
            ),
            const SizedBox(
              width: 30,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.model.userName!),
                Text(
                  widget.model.userIsOnline! ? 'Online' : 'Offline',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        widget.model.userIsOnline! ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ChatMessage(
                receiverId: widget.model.userUId!,
              ),
            ),
             ChatTextField(
               receiverId: widget.model.userUId!,
             ),
          ],
        ),
      ),
    );
  }


}
