import 'dart:developer';

import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wham/screens/home_screen.dart';
import 'package:wham/main_observer.dart';
import 'package:wham/paye/paye_cubit.dart';
import 'package:wham/paye/paye_screen.dart';
import 'package:wham/screens/new_client_screen.dart';
import 'package:wham/screens/settings_screen.dart';

import 'screens/invoices_screen.dart';
import 'screens/new_invoice_screen.dart';

final materialThemeData = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(color: Colors.blue.shade600),
    primaryColor: Colors.blue,
    secondaryHeaderColor: Colors.blue,
    canvasColor: Colors.blue,
    backgroundColor: Colors.red,
    textTheme:
        const TextTheme().copyWith(bodyText1: const TextTheme().bodyText2),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
        .copyWith(secondary: Colors.blue));

const cupertinoTheme = CupertinoThemeData(
    primaryColor: Colors.red,
    barBackgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white);

void main() {
  BlocOverrides.runZoned(
    () => runApp(App()),
    blocObserver: MainCubitObserver(),
  );
}

/// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application re-enter loading state,
/// which is undesired.
class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          log("error: ${snapshot.error}");
          return const Text('Something went wrong!',
              textDirection: TextDirection.ltr);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return const WhamApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Text('Loading...', textDirection: TextDirection.ltr);
      },
    );
  }
}

class WhamApp extends StatelessWidget {
  const WhamApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Wham!';
    return PlatformSnackApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      materialTheme: materialThemeData,
      cupertinoTheme: cupertinoTheme,
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const HomeScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/paye_calculator': (context) => BlocProvider(
              create: (context) => PayeCubit(),
              child: const PayEFormScreen(),
            ),
        '/invoices': (context) => const InvoicesScreen(),
        '/new_invoice': (context) => const NewInvoiceScreen(),
        '/new_client': (context) => const NewClientScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
