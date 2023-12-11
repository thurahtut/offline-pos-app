import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offline_pos/service/navigation_service.dart';
import 'package:offline_pos/view/login/login_screen.dart';

import 'components/routers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Offline POS',
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: LoginScreen.routeName,
      onGenerateRoute: Routers.generateRoute,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
