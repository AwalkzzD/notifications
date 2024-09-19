import 'dart:developer';

import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> with WidgetsBindingObserver {
  String fid = '';

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log('Got a message whilst in the foreground!');
        log('Message data: ${message.notification?.body}');

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.notification?.body ?? 'null')));
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Firebase Installation ID -> $fid'),
            ElevatedButton(
                onPressed: () async {
                  fid = await FirebaseInstallations.instance.getId();
                  log('Firebase Installation ID -> $fid');
                  setState(() {});
                },
                child: const Text('Get ID')),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseInstallations.instance.delete();
                  setState(() {});
                },
                child: const Text('Delete ID')),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
