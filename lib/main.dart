
import 'package:card_test/components/bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const Scentia());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xffefeff4),
  ));
}

class Scentia extends StatelessWidget {
  const Scentia({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Card Test',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.green,
      ),
      home: const BottomBar()
    );
  }
}