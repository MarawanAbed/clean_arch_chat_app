import 'dart:convert';

import 'package:clean_arch_chat/Chat/presentation/widgets/chat_message.dart';
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

  void _initLocalNotification() {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: (response) async {
        debugPrint(response.payload.toString());
      },
    );
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    if (message.notification != null) {
      final styleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        // <-- Accessing notification without null check
        htmlFormatBigText: true,
        contentTitle: message.notification!.title,
        // <-- Accessing notification without null check
        htmlFormatTitle: true,
      );
      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'com.example.clean_arch_chat.urgent',
          'mychannelid',
          importance: Importance.max,
          styleInformation: styleInformation,
          priority: Priority.max,
        ),
      );
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['body'],
      );
    } else {
      // Handle the case where message.notification is null
      // You can log an error or take other appropriate action here
    }
  }

  Future<void> requestPermission() async {
    final message = FirebaseMessaging.instance;
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

  void firebaseNotification(context) {
    _initLocalNotification();
    //background notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ChatMessage(
                receiverId: message.data['senderId'],
              )));
    });

    FirebaseMessaging.onMessage.listen((message) async {
      await _showLocalNotification(message);
    });
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
            "date": <String, String>{
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "status": "done",
              "senderId": senderId,
            }
          },
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
