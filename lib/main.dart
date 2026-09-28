import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pro_persona/app/app.dart';
import 'package:pro_persona/core/config/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: FirebaseConfig.currentPlatform);
  runApp(const ProPersonaApp());
}
