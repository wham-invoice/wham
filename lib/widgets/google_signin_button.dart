import 'package:firebase_auth/firebase_auth.dart' as f_auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loggy/loggy.dart';
import 'package:wham/schema/user.dart';

import 'package:wham/utils/authentication.dart';

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
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });
                f_auth.User? fUser = await Authentication.signInWithGoogle(
                    context: context, gSignIn: widget.gSignIn);

                setState(() {
                  _isSigningIn = false;
                });

                if (fUser != null) {
                  Authentication.onSignIn(
                      context: context,
                      logger: loggy,
                      firebaseUser: fUser,
                      gSignIn: widget.gSignIn);
                }
              },
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
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
