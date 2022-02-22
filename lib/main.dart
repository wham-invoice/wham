import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:loggy/loggy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wham/screens/invoice_detail_screen.dart';
import 'package:wham/screens/sign_in_screen.dart';
import 'package:wham/screens/home_screen.dart';
import 'package:wham/main_observer.dart';
import 'package:wham/screens/new_contact_screen.dart';
import 'screens/invoices_screen.dart';
import 'screens/contacts_screen.dart';
import 'screens/new_invoice_screen.dart';

final materialThemeData = ThemeData(
    scaffoldBackgroundColor: Colors.black26,
    appBarTheme: AppBarTheme(color: Colors.blue.shade600),
    primaryColor: Colors.blue,
    secondaryHeaderColor: Colors.blue,
    canvasColor: Colors.blue,
    backgroundColor: Colors.red,
    textTheme:
        const TextTheme().copyWith(bodyText1: const TextTheme().bodyText2),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
        .copyWith(secondary: Colors.blue));

const cupertinoThemeData = CupertinoThemeData(
    primaryColor: Colors.red,
    barBackgroundColor: CupertinoColors.black,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color.fromRGBO(13, 28, 56, 1.0),
    textTheme: CupertinoTextThemeData(
      primaryColor: CupertinoColors.white,
      textStyle: TextStyle(color: CupertinoColors.white),
    ));

void main() {
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(
      showColors: true,
    ),
    logOptions: const LogOptions(
      LogLevel.all,
      stackTraceLevel: LogLevel.off,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();

  BlocOverrides.runZoned(
    () => runApp(const WhamApp()),
    blocObserver: MainCubitObserver(),
  );
}

class WhamApp extends StatelessWidget {
  const WhamApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PlatformSnackApp(
        title: 'Wham!',
        debugShowCheckedModeBanner: false,
        materialTheme: materialThemeData,
        cupertinoTheme: cupertinoThemeData,
        initialRoute: SignInScreen.routeName,
        routes: {
          HomeScreen.routeName: (context) => const HomeScreen(),
          InvoicesScreen.routeName: (context) => const InvoicesScreen(),
          InvoiceDetailScreen.routeName: (context) =>
              const InvoiceDetailScreen(),
          NewInvoiceScreen.routeName: (context) => const NewInvoiceScreen(),
          ContactsScreen.routeName: (context) => const ContactsScreen(),
          NewContactScreen.routeName: (context) => const NewContactScreen(),
          SignInScreen.routeName: (context) =>
              Builder(builder: (context) => const SignInScreen()),
        },
      );
}
