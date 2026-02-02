import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'; // Needed to check if running on Web (kIsWeb)

import 'login_screen.dart'; 

void main() async {
  // 1. Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase with logic for different platforms
  if (kIsWeb) {
    // Web requires explicit Firebase options
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "PASTE_YOUR_API_KEY_HERE", 
        appId: "PASTE_YOUR_APP_ID_HERE", 
        messagingSenderId: "PASTE_YOUR_SENDER_ID_HERE", 
        projectId: "PASTE_YOUR_PROJECT_ID_HERE", 
        storageBucket: "PASTE_YOUR_STORAGE_BUCKET_HERE",
      ),
    );
  } else {
    // Mobile platforms (Android/iOS) auto-detect configuration
    await Firebase.initializeApp();
  }

  // 3. Run the App
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the "Debug" banner
      title: 'Resident Space App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: LoginScreen(), 
    );
  }
}