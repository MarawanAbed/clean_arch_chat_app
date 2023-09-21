

import 'package:clean_arch_chat/Chat/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends UserEntity {
  final String uId;
  final String name;
  final String email;
  final String image;
  final String password;
  final DateTime lastActive;
  final bool isOnline;

  UserModel( {
    required this.password,
    required this.uId,
    required this.name,
    required this.email,
    required this.image,
    required this.lastActive,
    required this.isOnline,
  }) : super(
            userUId: uId,
            userName: name,
            userEmail: email,
            userImage: image,
            userLastActive: lastActive,
            userIsOnline: isOnline,
            userPassword: password
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime lastActiveDateTime;

    try {
      final lastActive = json['lastActive'];
      if (lastActive is String) {
        lastActiveDateTime = DateTime.parse(lastActive);
      } else if (lastActive is Timestamp) {
        lastActiveDateTime = lastActive.toDate();
      } else {
        // Handle other cases or set a default value
        lastActiveDateTime = DateTime.now();
      }
    } catch (e) {
      // Handle any parsing errors here
      lastActiveDateTime = DateTime.now();
    }

    return UserModel(
      password: json['password'],
      uId: json['uId'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
      lastActive: lastActiveDateTime,
      isOnline: json['isOnline'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'name': name,
      'email': email,
      'image': image,
      'lastActive': lastActive,
      'isOnline': isOnline,
      'password': password,
    };
  }
}
