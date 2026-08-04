//lib\main.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noti_chat/core/services/notification_service.dart';
import 'package:noti_chat/firebase_options.dart';
import 'package:noti_chat/ui/views/chat/chat_view_model.dart';
import 'package:noti_chat/ui/views/home/home_view.dart';
import 'package:noti_chat/ui/views/home/home_view_model.dart';
import 'package:noti_chat/ui/views/signIN/sign_in_view.dart';
import 'package:noti_chat/ui/views/signIN/sign_in_view_model.dart';
import 'package:noti_chat/ui/views/signUp/sign_up_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.instance.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignUpViewModel()),
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ChangeNotifierProvider(create: (context) => SignInViewModel()),
        ChangeNotifierProvider(create: (context) => ChatViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notifications Chat App',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return HomeView();
          }
          return SignInView();
        },
      ),
    );
  }
}
