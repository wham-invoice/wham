import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:loggy/loggy.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wham/widgets/google_signin_button.dart';

import '../network/auth/google_auth.dart';
import '../widgets/snackbar.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/';

  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with UiLoggy {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[GmailApi.gmailComposeScope, GmailApi.gmailSendScope],
  );

  // _attemptSilentSignIn attempts to sign in a previously authenticated user without interaction.
  Future<void> _attemptSilentSignIn({
    required BuildContext ctx,
    required Loggy<UiLoggy> logger,
  }) async {
    GoogleSignInAccount? user = await _googleSignIn.signInSilently();

    if (user == null) {
      logger.info("silent sign in: no user signed in");
      return;
    }

    await GoogleAuth.onSignIn(ctx: ctx, logger: logger, user: user);
  }

  @override
  Widget build(BuildContext ctx) {
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
                ctx: ctx,
                logger: loggy,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  loggy.error(snapshot.error);
                  Snack.errorSnackBar(content: "error signing in ");
                  GoogleAuth.signOut(logger: loggy, ctx: context);
                }

                // we attempted to sign in silently, but there was no user signed in.
                // we need to show the sign in button.
                if (snapshot.connectionState == ConnectionState.done) {
                  return GoogleSignInButton(_googleSignIn);
                }

                return PlatformText("loading");
              },
            ),
          ),
        ),
      ),
    );
  }
}
