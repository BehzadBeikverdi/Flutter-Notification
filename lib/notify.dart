import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notification/second_screen.dart';

import 'main.dart';

class Notify extends StatefulWidget {
  const Notify({Key? key}) : super(key: key);

  @override
  State<Notify> createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

  // GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

  FlutterLocalNotificationsPlugin? localNotifications;

  @override
  void initState() {
    super.initState();

    var androidInitialize = const AndroidInitializationSettings('ic_app_logo');

    var iOSInitialize = const IOSInitializationSettings(
      // requestAlertPermission: true,
      // requestBadgePermission: true,
      // requestSoundPermission: true,
    );

    var initializationSettings = InitializationSettings(
      android: androidInitialize, iOS: iOSInitialize
    );

    localNotifications = FlutterLocalNotificationsPlugin();
    localNotifications?.initialize(initializationSettings, onSelectNotification: selectNotification);

    runLocalNotification() async {
      final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

      if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
        // redirect to new screen if true.
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
          const SecondScreen()),);
      }
    }
    runLocalNotification();
  }

  Future showNotification() async{
    var androidDetails = const AndroidNotificationDetails("android_channel_id", "Local notifications",
        playSound: true,
        importance: Importance.max,
        // priority: Priority.max,
        fullScreenIntent: true,
        enableLights: true,
        enableVibration: true,
        // groupAlertBehavior: GroupAlertBehavior.all,
        // visibility: NotificationVisibility.public,
        // category: "Importance",
        // ticker: "Ticker",
        ongoing: true,
        // setAsGroupSummary: true,
        // showProgress: true,
        showWhen: true,
        // progress: 10,
        // usesChronometer: true,
        indeterminate: true,
        styleInformation: BigTextStyleInformation(''),
        // sound: RawResourceAndroidNotificationSound('arrive')
    );

    var iOSDetails =  const IOSNotificationDetails(presentSound: true);

    var generateNotificationDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails,);

    await localNotifications?.show(0, "Iran SIgn", "Please sign the document", generateNotificationDetails);

    // final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    // await localNotifications?.getNotificationAppLaunchDetails();
    // final didNotificationLaunchApp =
    //     notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
    // final initialRoute = didNotificationLaunchApp ? const SecondScreen() : const Notify();
    // initialRoute;
  }

  void selectNotification(body) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          const SecondScreen()),);
    // navigatorKey.currentState?.push(
    //     MaterialPageRoute(builder: (context) => const SecondScreen())
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Notify'), centerTitle: true,),
      body: Center(
        child: RaisedButton.icon(
            onPressed: () {
              showNotification();
            },
            label: const Text("Click here to receive notify"),
            icon: const Icon(Icons.notifications_active),
        ),
      ),
    );
  }
}
