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

class WhamApp extends StatefulWidget {
  const WhamApp({Key? key}) : super(key: key);

  @override
  _WhamAppState createState() => _WhamAppState();
}

class _WhamAppState extends State {
  @override
  Widget build(BuildContext context) {
    final materialTheme = ThemeData(
      primarySwatch: Colors.blue,
      textTheme: Typography.whiteMountainView,
      brightness: Brightness.dark,
    );

    return Theme(
      data: materialTheme,
      child: PlatformProvider(
        //initialPlatform: TargetPlatform.android,
        settings: PlatformSettingsData(iosUsesMaterialWidgets: true),
        builder: (context) => PlatformSnackApp(
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          title: 'Wham',
          debugShowCheckedModeBanner: false,
          materialTheme: materialTheme,
          cupertinoTheme:
              MaterialBasedCupertinoThemeData(materialTheme: materialTheme),
          initialRoute: SignInScreen.routeName,
          routes: {
            HomeScreen.routeName: (context) => const HomeScreen(),
            InvoicesScreen.routeName: (context) => const InvoicesScreen(),
            ContactsScreen.routeName: (context) => const ContactsScreen(),
            SignInScreen.routeName: (context) =>
                Builder(builder: (context) => const SignInScreen()),
          },
          onGenerateRoute: (RouteSettings settings) {
            final String routeName = settings.name ?? '';

            switch (routeName) {
              case NewContactScreen.routeName:
                return platformPageRoute<bool>(
                  context: context,
                  builder: (BuildContext context) => const NewContactScreen(),
                  settings: settings,
                );
              case NewInvoiceScreen.routeName:
                return platformPageRoute<bool>(
                  context: context,
                  builder: (BuildContext context) => const NewInvoiceScreen(),
                  settings: settings,
                );
              case InvoiceDetailScreen.routeName:
                return platformPageRoute<bool>(
                  context: context,
                  builder: (BuildContext context) =>
                      const InvoiceDetailScreen(),
                  settings: settings,
                );
            }

            throw Exception('Unknown route: $routeName');
          },
        ),
      ),
    );
  }
}
