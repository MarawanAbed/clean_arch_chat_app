
import 'package:clean_arch_chat/Chat/domain/entities/user_entity.dart';
import 'package:clean_arch_chat/Chat/presentation/pages/chat.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserItem extends StatelessWidget {
  const UserItem({super.key, required this.userEntity});

  final UserEntity userEntity;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      model: userEntity,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: ListTile(
          leading: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(userEntity.userImage!),
              ),
              CircleAvatar(
                radius: 6,
                backgroundColor:
                userEntity.userIsOnline! ? Colors.green : Colors.grey,
              ),
            ],
          ),
          title: Text(userEntity.userName!),
          //format widget.userModel.lastActive

          subtitle:
              Text('Last Active : ${timeago.format(userEntity.userLastActive!)}',
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.grey,
                  )),
        ),
      ),
    );
  }
}
