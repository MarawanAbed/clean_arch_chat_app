import 'package:clean_arch_chat/Chat/presentation/manager/chat/chat_cubit.dart';
import 'package:clean_arch_chat/Chat/presentation/widgets/messageBubble.dart';
import 'package:clean_arch_chat/utils/services/notification_services.dart';
import 'package:clean_arch_chat/utils/services/show_snack_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key, required this.receiverId});

  final String receiverId;

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  static final notificationServices = NotificationServices();
  @override
  void initState() {
    notificationServices.firebaseNotification(context);
    final cubit = ChatCubit.get(context);
    cubit.getMessages(widget.receiverId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatGetAllMessagesError) {
          return Utils.showSnackBar(state.error);
        }
        var cubit = ChatCubit.get(context);
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            final message = cubit.message[index];
            //check if the message is sent by me or not
            //equal to the receiver id then its sent by me
            //else its sent by the other user
            final isMe = message.chatSenderId != widget.receiverId;
            return MessageBubble(
              isMe: isMe,
              messageModel: cubit.message[index],
            );
          },
          itemCount: cubit.message.length,
        );
      },
    );
  }
}
