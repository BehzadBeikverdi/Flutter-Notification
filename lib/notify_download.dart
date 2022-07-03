import 'dart:isolate';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notification/second_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'main.dart';

class NotifyDownload extends StatefulWidget {
  const NotifyDownload({Key? key}) : super(key: key);

  @override
  State<NotifyDownload> createState() => _NotifyDownloadState();
}

class _NotifyDownloadState extends State<NotifyDownload> {

  FlutterLocalNotificationsPlugin? localNotifications;

  static downloadCallback(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloadingPdf");
    sendPort?.send(progress);
  }

  int progress = 0;
  ReceivePort receivePort = ReceivePort();
  @override
  void initState() {
    IsolateNameServer.registerPortWithName(receivePort.sendPort, "downloadingPdf");

    receivePort.listen((message) {
      setState(() {
        progress = message;
      });
    });

    FlutterDownloader.registerCallback(downloadCallback);
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

    // runLocalNotification() async {
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
    // runLocalNotification();
  }

  Future showNotification() async{
    var androidDetails = const AndroidNotificationDetails("android_channel_id", "Local notifications",
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
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

    await localNotifications?.show(0, "Iran SIgn", "Download the document", generateNotificationDetails);

    // final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    // await localNotifications?.getNotificationAppLaunchDetails();
    // final didNotificationLaunchApp =
    //     notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
    // final initialRoute = didNotificationLaunchApp ? const SecondScreen() : const Notify();
    // initialRoute;

  }

  void downloadFile() async {
    var url = "https://cvbuilder.me/Builder/Pdf/fa/template33/a5970bb1-db76-4ae8-9d29-7c58b9a4f127/MyResume-551[www.cvbuilder.me].pdf";
    String saveLoc= "/storage/emulated/0/Download";
    // await FlutterDownloader.enqueue(
    //   url: 'https://cvbuilder.me/Builder/Pdf/fa/template33/a5970bb1-db76-4ae8-9d29-7c58b9a4f127/MyResume-551[www.cvbuilder.me].pdf',
    //   savedDir: '/storage/emulated/0/Download',
    //   fileName: "My Resume",
    //   showNotification: true, // show download progress in status bar (for Android)
    //   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    // );
    // Dio? dio;
    // await dio?.download(url, saveLoc,
    //     onReceiveProgress: (received, total) {
    //       if (total != -1) {
    //         print("Rec: $received , Total: $total");
    //         debugPrint("Directory path : $saveLoc/$fileName");
    //         int percentage = ((received / total) * 100).floor();
    //         print("$percentage");
    //         // setState(() {
    //         //   downloadProgressString =
    //         //       ((received / total) * 100).toStringAsFixed(0) + "%";
    //         // });
    //       }
    //     });

    // await FlutterDownloader.enqueue(url: url,
    //     savedDir: saveLoc, fileName: 'SampleFile');

    final statusPermission = await Permission.storage.request();

    if(statusPermission.isGranted) {

      final baseStorage = await getExternalStorageDirectory();

      await FlutterDownloader.enqueue(url: url,
          savedDir: saveLoc, fileName: 'MyResume.pdf');

    }else {
      print("No Permission");
    }
  }
  void selectNotification(body) async {
    downloadFile();
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) =>
    //   const SecondScreen()),);
    // // navigatorKey.currentState?.push(
    // //     MaterialPageRoute(builder: (context) => const SecondScreen())
    // // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Notify'), centerTitle: true,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton.icon(
            onPressed: () {
              showNotification();
              // FlutterDownloader.initialize();
              // downloadFile();
            },
            label: const Text("Click here to download pdf"),
            icon: const Icon(Icons.cloud_download),
          ),
          const Divider(
            height: 30,
            color: Colors.white,
          ),
          Container(
            height: 100,
            width: 300,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: <Widget>[
                const Text("Download percentage", style: TextStyle(fontSize: 20, color: Colors.black)),
                const Divider(
                  height: 30,
                  color: Colors.white,
                ),
                Text("$progress %", style: const TextStyle(fontSize: 20, color: Colors.black),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // void progressDownload(BuildContext context) {
  //   showGeneralDialog(
  //     context: context,
  //     barrierLabel: "Barrier",
  //     barrierDismissible: true,
  //     barrierColor: Colors.black.withOpacity(0.5),
  //     transitionDuration: Duration(milliseconds: 700),
  //     pageBuilder: (_, __, ___) {
  //       return Center(
  //         child: Container(
  //           height: 100,
  //           width: 300,
  //           margin: EdgeInsets.symmetric(horizontal: 20),
  //           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
  //           child: Column(
  //             children: <Widget>[
  //               const Text("Download percentage", style: TextStyle(fontSize: 20, color: Colors.black)),
  //               const Divider(
  //                 height: 30,
  //                 color: Colors.white,
  //               ),
  //               Text("$progress %", style: const TextStyle(fontSize: 20, color: Colors.black),),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
