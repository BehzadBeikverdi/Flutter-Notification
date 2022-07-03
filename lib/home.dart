import 'package:flutter/material.dart';

import 'notify_download.dart';
import 'notify_message.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Flutter Notify'),),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 200,
                child: RaisedButton.icon(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  const NotifyMessage()));
                }, label: const Text("Notify Message"),
                  icon: const Icon(Icons.message_outlined),),
              ),
              const Divider(
                height: 50,
              ),
              SizedBox(
                width: 200,
                child: RaisedButton.icon(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  const NotifyDownload()));
                }, label: const Text("Notify Download"),
                  icon: const Icon(Icons.file_download),),
              )
            ],
          ),
        ));
  }
}
