import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:wham/screens/utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    final welcomeBackMsg = "Welcome back " + args.user.uid;

    return PlatformScaffold(
        appBar: PlatformAppBar(),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                //   child: PlatformElevatedButton(
                //     onPressed: () {
                //       Navigator.pushNamed(context, '/paye_calculator');
                //     },
                //     child: const Text('PayE calculator'),
                //   ),
                // ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformText(welcomeBackMsg),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/new_invoice');
                    },
                    child: const Text('New Invoice'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/new_client');
                    },
                    child: const Text('New Client'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/invoices');
                    },
                    child: const Text('Invoices'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/sign-in');
                    },
                    child: const Text('Sign In'),
                  ),
                ),
              ]),
        ));
  }
}
