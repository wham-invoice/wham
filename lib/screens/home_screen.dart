import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:wham/screens/contacts_screen.dart';
import 'package:wham/screens/invoices_screen.dart';
import 'package:wham/screens/sign_in_screen.dart';
import 'package:wham/screens/utils.dart';
import 'package:wham/widgets/invoice_summary.dart';

import '../network/auth/google_auth.dart';

class HomeScreen extends StatelessWidget with UiLoggy {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    const signOutSnackBar = SnackBar(
      content: Text('Signing out'),
    );

    return PlatformScaffold(
        appBar: PlatformAppBar(),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: InvoiceSummary(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        InvoicesScreen.routeName,
                        arguments: ScreenArguments(args.signedInUser),
                      );
                    },
                    child: PlatformText('Invoices'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        ContactsScreen.routeName,
                        arguments: ScreenArguments(args.signedInUser),
                      );
                    },
                    child: PlatformText('Contacts'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformElevatedButton(
                    onPressed: () async {
                      loggy.info("user pressed sign out");
                      ScaffoldMessenger.of(context)
                          .showSnackBar(signOutSnackBar);
                      await GoogleAuth.signOut(context: context);

                      Navigator.of(context)
                          .pushReplacementNamed(SignInScreen.routeName);
                    },
                    child: const Text('Sign out'),
                  ),
                ),
              ]),
        ));
  }
}
