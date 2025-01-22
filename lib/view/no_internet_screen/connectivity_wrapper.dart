// import 'package:flutter/material.dart';
// import 'package:projecthub/view/app_navigation_bar/app_navigation_bar.dart';
// import 'package:projecthub/view/splash/splash_screen.dart';
// import 'package:provider/provider.dart';

// import '../home/home_screen.dart';
// import 'connectivity_service.dart';
// import 'no_intermet_screen.dart';

// class ConnectivityWrapper extends StatefulWidget {
//   const ConnectivityWrapper({super.key});

//   @override
//   _ConnectivityWrapperState createState() => _ConnectivityWrapperState();
// }

// class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
//   @override
//   void initState() {
//     super.initState();
//     // Register the context to be used for navigation.
//     Provider.of<ConnectivityProvider>(context, listen: false)
//         .setContext(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ConnectivityProvider>(
//       builder: (context, provider, child) {
//         if (provider.isConnected) {
//           return const Splashscreen();
//         } else {
//           return const NoInternetScreen();
//         }
//       },
//     );
//   }
// }
