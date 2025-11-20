import 'package:flutter/material.dart';
import 'package:flutterzinho/create_account.dart';
import 'calendar.dart';
import 'login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/create': (context) => CreateAccountPage(),
        '/calendar': (context) => CalendarPage(),
      },
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF37A686),
          selectionHandleColor: Color(0xFF37A686),
        ),
        dialogTheme: const DialogThemeData(backgroundColor: Color(0xF1F2F2F2)),

        colorScheme: ColorScheme.light(
          surface: Color(0xFFF2F2F2),
          surfaceDim: Color(0xF9F2F2F2),
          primary: Color(0xFF52F2B8),
          onSurface: Color(0xFF0D0D0D),
          outline: Color(0xFF0D0D0D),
          outlineVariant: Color(0xFF37A686),
        ),
      ),
    );
  }
}
