import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:projecthub/app_providers/creation_provider.dart';
import 'package:projecthub/app_providers/data_file_provider.dart';
import 'package:projecthub/app_providers/user_provider.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'view/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Hide the status bar
  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent, // Transparent status bar
  //     statusBarBrightness:
  //         Brightness.light, // Adjust brightness for better visibility
  //     statusBarIconBrightness: Brightness.light, // Adjust icon brightness
  //   ),
  // );

  // // Hide the status bar
  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.manual,
  //   overlays: [SystemUiOverlay.bottom], // Only show the navigation bar
  // );

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyAGu-IqmaAGi8hnnhNs4F0XqVdX5fkdUeU',
      appId: '1:812047731231:android:1eef5f19208e209eeda32a',
      messagingSenderId: '812047731231',
      projectId: 'projecthu-shop',
    ));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataFileProvider()),
        ChangeNotifierProvider(create: (_) => UserInfoProvider()),
        ChangeNotifierProvider(create: (_) => ListedCreationProvider()),
        ChangeNotifierProvider(create: (_) => GeneralCreationProvider()),
        ChangeNotifierProvider(create: (_) => RecentCreationProvider()),
        ChangeNotifierProvider(create: (_) => TreandingCreationProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColor.bgColor,
          iconTheme: IconThemeData(
            color:
                AppColor.primaryColor, // Sets the default color for all icons
            size: 21,
          ),
          appBarTheme: AppBarTheme(
            color: AppColor.bgColor,
            iconTheme: const IconThemeData(color: Colors.black),
            titleTextStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 51, 51, 51),
            ),
          ),
          textTheme: TextTheme(
            headlineLarge: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
            headlineMedium: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        home: const Splashscreen(),
      ),
    );
  }
}
