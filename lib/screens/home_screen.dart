import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                //   child: PlatformElevatedButton(
                //     onPressed: () {
                //       Navigator.pushNamed(context, '/settings');
                //     },
                //     child: const Text('Settings'),
                //   ),
                // ),
              ]),
        ));
  }
}
