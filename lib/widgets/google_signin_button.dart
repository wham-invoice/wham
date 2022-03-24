import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loggy/loggy.dart';

import '../network/auth/google_auth.dart';

class GoogleSignInButton extends StatefulWidget {
  final GoogleSignIn gSignIn;
  const GoogleSignInButton(this.gSignIn, {Key? key}) : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> with UiLoggy {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? PlatformText(
              "signing in to wham",
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });
                GoogleSignInAccount? user = await widget.gSignIn.signIn();

                try {
                  if (user == null) {
                    throw Exception('no user signed in');
                  }
                  await GoogleAuth.onSignIn(
                      ctx: ctx, logger: loggy, user: user);
                } catch (e) {
                  setState(() {
                    _isSigningIn = false;
                  });
                  loggy.error('error signing into google ', e);
                  await GoogleAuth.signOut(ctx: ctx, logger: loggy);
                }
              },
            ),
    );
  }
}
