// import 'package:flutter/material.dart';

// import 'screens/home.dart';
// import 'login.dart';

// class ShrineApp extends StatelessWidget {
//   const ShrineApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: '22000646',
//       home: const HomePage(),
//       initialRoute: '/login',
//       onGenerateRoute: _getRoute,
//     );
//   }

//   Route<dynamic>? _getRoute(RouteSettings settings) {
//     if (settings.name != '/login') {
//       return null;
//     }

//     return MaterialPageRoute<void>(
//       settings: settings,
//       builder: (BuildContext context) => const LoginPage(),
//       fullscreenDialog: true,
//     );
//   }
// }
