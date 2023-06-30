

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import 'package:push_notification_demo/main.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void showNotification(){
    flutterLocalNotificationsPlugin.show(0, //id,
        'testing .....' , //title
        "How you do in?",
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                importance: Importance.high,
                color: Colors.pink,
                playSound: true,
                icon: '@mipmap/ic_launcher'

            )
        )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//this method call when app in terminated state and you get a notification
    FirebaseMessaging.instance.getInitialMessage().then(
            (message) {
          print("FirebaseMessaging.instance.getInitialMessage");
          if (message != null) {
            print("New Notification");
          }
        }
    );


//To handle messages while your application is in the foreground, listen to the onMessage stream.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      print('got a msg whilst in foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null && android != null) {
        print('Message also contained a notification: ${message.notification}');
        flutterLocalNotificationsPlugin.show(notification.hashCode,
            notification?.title,
            notification?.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id,
                    channel.name,
                    color: Colors.green,
                    playSound: true,
                    icon: '@mipmap/ic_launcher'
                )
            )
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        showDialog(context: context, builder: (_) {
          return AlertDialog(
            title: Text(notification?.title ?? ''),
            content: Text(notification?.body ?? ''),
          );
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: showNotification,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}