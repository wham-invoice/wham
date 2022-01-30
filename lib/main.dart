import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:loggy/loggy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wham/screens/invoice_detail_screen.dart';
import 'package:wham/screens/sign_in_screen.dart';
import 'package:wham/screens/home_screen.dart';
import 'package:wham/main_observer.dart';
import 'package:wham/paye/paye_cubit.dart';
import 'package:wham/paye/paye_screen.dart';
import 'package:wham/screens/new_contact_screen.dart';
import 'screens/invoices_screen.dart';
import 'screens/contacts_screen.dart';
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
  Widget build(BuildContext context) {
    const appTitle = 'Wham!';
    return PlatformSnackApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      materialTheme: materialThemeData,
      cupertinoTheme: cupertinoTheme,
      initialRoute: SignInScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        '/paye_calculator': (context) => BlocProvider(
              create: (context) => PayeCubit(),
              child: const PayEFormScreen(),
            ),
        InvoicesScreen.routeName: (context) => const InvoicesScreen(),
        InvoiceDetailScreen.routeName: (context) => const InvoiceDetailScreen(),
        NewInvoiceScreen.routeName: (context) => const NewInvoiceScreen(),
        ContactsScreen.routeName: (context) => const ContactsScreen(),
        NewContactScreen.routeName: (context) => const NewContactScreen(),
        SignInScreen.routeName: (context) =>
            Builder(builder: (context) => const SignInScreen()),
      },
    );
  }
}
