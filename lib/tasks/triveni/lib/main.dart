import 'package:flutter/material.dart'; 

import 'package:firebase_core/firebase_core.dart'; 

import 'package:flutter/foundation.dart' show kIsWeb;

import 'screens/home_screen.dart'; 

  

// main() is async because Firebase.initializeApp() is an async operation 

void main() async { 

  // This MUST come first — ensures Flutter engine is ready before Firebase init 

  WidgetsFlutterBinding.ensureInitialized(); 

  

  // Initialize Firebase — connects app to your Firebase project 

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCk5WDlR6Z75g4ztOn6KR5cc5__y69P6jQ",
          authDomain: "appdev-3bd50.firebaseapp.com",
          projectId: "appdev-3bd50",
          storageBucket: "appdev-3bd50.firebasestorage.app",
          messagingSenderId: "369906240263",
          appId: "1:369906240263:android:a89f9a02ddfbdbeb9bd3a2",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  

  runApp(const MyApp()); 

} 


  

class MyApp extends StatelessWidget { 

  const MyApp({super.key}); 

  

  @override 

  Widget build(BuildContext context) { 

    return MaterialApp( 

      title: 'Student App', 

      debugShowCheckedModeBanner: false,  // Removes the red DEBUG banner 

      theme: ThemeData( 

        colorScheme: ColorScheme.fromSeed( 

          seedColor: const Color(0xFFF5C518), 

        ), 

        useMaterial3: true, 

        appBarTheme: const AppBarTheme( 

          backgroundColor: Color(0xFFF5C518),  // Yellow app bar 

          foregroundColor: Colors.black, 

          centerTitle: true, 

          elevation: 0, 

        ), 

      ), 

      home: const HomeScreen(), 

    ); 

  } 

} 