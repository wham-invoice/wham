import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:loggy/loggy.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wham/widgets/google_signin_button.dart';

import '../network/auth/google_auth.dart';
import '../widgets/snackbar.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/sign-in';

  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with UiLoggy {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[GmailApi.gmailComposeScope],
  );

  //Attempts to sign in a previously authenticated user without interaction.
  //If the currently signed in user errors whilst authenticating w BE we sign out.
  Future<void> _attemptSilentSignIn({
    required BuildContext context,
    required Loggy<UiLoggy> logger,
    required GoogleSignIn gSignIn,
  }) async {
    GoogleSignInAccount? account = await gSignIn.signInSilently();

    if (account != null) {
      try {
        await GoogleAuth.signIn(
            context: context, logger: logger, gSignIn: gSignIn);
      } catch (e) {
        logger.error('Error signing in silently ${e.toString()}', e);
        // should this be auth.signOut()?
        await gSignIn.signOut();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Center(
            child: FutureBuilder(
              future: _attemptSilentSignIn(
                  context: context, logger: loggy, gSignIn: _googleSignIn),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  loggy.error(snapshot.error);
                  Snack.errorSnackBar(
                      content:
                          "Error signing in ${snapshot.error}. signing out.");
                  GoogleAuth.signOut(context: context);
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return GoogleSignInButton(_googleSignIn);
                }

                return const Text("Loading");
              },
            ),
          ),
        ),
      ),
    );
  }
}
