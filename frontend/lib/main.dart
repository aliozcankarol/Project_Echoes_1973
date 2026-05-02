import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/main_screen.dart';
import 'services/echo_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure you've followed the Firebase setup instructions 
  // (e.g. adding google-services.json for Android / GoogleService-Info.plist for iOS)
  // For web, you'll need the Firebase configuration options here or in index.html.
  // We're wrapping it in a try-catch for demonstration since configuration might not be fully complete.
  try {
    if (kIsWeb) {
      // Provide dummy options for local web testing so Firebase doesn't crash
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "dummy-key",
          appId: "1:1234567890:web:1234567890",
          messagingSenderId: "1234567890",
          projectId: "demo-no-project",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EchoService()),
      ],
      child: const EchoesOf1973App(),
    ),
  );
}

class EchoesOf1973App extends StatelessWidget {
  const EchoesOf1973App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Echoes of 1973',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
