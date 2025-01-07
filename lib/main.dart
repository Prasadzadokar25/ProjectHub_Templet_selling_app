import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecthub/config/data_file_provider.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'view/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColor.bgColor,
          iconTheme: IconThemeData(
            color:
                AppColor.primaryColor, // Sets the default color for all icons
            size: 21
            ,
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
