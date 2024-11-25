import 'package:flutter/material.dart';
import 'package:setalarm/AlarmNotifications.dart';
import 'package:setalarm/alarmScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AlarmNotifiction.init();
  runApp(Setalarm());
}

class Setalarm extends StatefulWidget {
  const Setalarm({super.key});

  @override
  State<Setalarm> createState() => _SetalarmState();
}

class _SetalarmState extends State<Setalarm> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Alarmscreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}