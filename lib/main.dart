import 'package:flutter/material.dart';
import 'screens/invitation_screen.dart';

void main() {
  runApp(const ValentineApp());
}

class ValentineApp extends StatelessWidget {
  const ValentineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valentine for Biba',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
      home: const InvitationScreen(),
    );
  }
}
