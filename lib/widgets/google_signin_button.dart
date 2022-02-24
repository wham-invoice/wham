import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loggy/loggy.dart';

import '../network/auth/google_auth.dart';

class GoogleSignInButton extends StatefulWidget {
  final GoogleSignIn gSignIn;
  const GoogleSignInButton(this.gSignIn);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> with UiLoggy {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? const Text(
              "Loading... from button",
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
                GoogleSignInAccount? googleSignInAccount =
                    await widget.gSignIn.signIn();

                if (googleSignInAccount != null) {
                  await GoogleAuth.signIn(
                      context: context, logger: loggy, gSignIn: widget.gSignIn);
                } else {
                  loggy.error("Google sign in failed");
                  setState(() {
                    _isSigningIn = false;
                  });
                }
              },
            ),
    );
  }
}
