import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notification/home.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async{
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  // void initState() {
  //   super.initState();
  //   localNotification(); // call below localNotification() here.
  // }
  //
  // localNotification() async {
  //   final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  //   await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  //
  //   if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
  //     // redirect to new screen if true.
  //     await Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) =>
  //       const SecondScreen()),);
  //   }
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // title: 'Flutter Notify',
      debugShowCheckedModeBanner: false,
      home: Home()
    );
  }
}
