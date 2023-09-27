import 'dart:convert';

import 'package:clean_arch_chat/Chat/presentation/widgets/chat_message.dart';
import 'package:clean_arch_chat/utils/services/show_snack_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationServices {
  static const key =
      'AAAAzUWaro8:APA91bFY-p3QIlEyAWJNqjQVPgRDFVFpj0aTNEsQb_OmA7ELGdWHGBS0Zzw106GnYzckrEbDX-Br_3gWAMbN_JzCTyXE0UKQgr8NOhGuR0RUWJjwR4pqUyRDgyVQHN0J287SqOfUGQrd';
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void firebaseNotification(context) {
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ChatMessage(receiverId: message.data['senderId'])));
    });
  }

  Future<void> requestPermission() async {
    final message = await FirebaseMessaging.instance;
    final settings = await message.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    _saveToken(token!);
  }

  Future<void> _saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token': token},
            SetOptions(merge: true)); //replace token each time we login
  }

  String receiverToken = '';

  Future<void> getReceiverToken(String receiverId) async {
    final getToken = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();
    receiverToken = await getToken.data()!['token'];
  }

  Future<void> sendNotification(
      {required String body, required String senderId}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$key',
        },
        body: jsonEncode(
          <String, dynamic>{
            "to": receiverToken,
            "priority": "high",
            "notification": <String, dynamic>{
              "body": body,
              "title": "New Message",
            },
            "data": <String, String>{
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "status": "done",
              "senderId": senderId,
            }
          },
        ),
      );
      Utils.showSnackBar('Notification sent');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
