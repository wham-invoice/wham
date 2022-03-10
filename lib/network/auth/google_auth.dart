import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loggy/loggy.dart';
import 'package:wham/firebase_options.dart';
import 'package:wham/schema/user.dart';

import '../../screens/home_screen.dart';
import '../../screens/utils.dart';
import '../../widgets/snackbar.dart';
import '../requests.dart';
import '../session.dart';

class GoogleAuth with UiLoggy {
  static Future<void> signIn({
    required BuildContext context,
    required Loggy<UiLoggy> logger,
    required GoogleSignIn gSignIn,
  }) async {
    final Session session = Session();
    final gUser = gSignIn.currentUser!;

    String? serverCode = gUser.serverAuthCode;
    if (serverCode == null || serverCode == "") {
      throw Exception("expected server code");
    }

    final GoogleSignInAuthentication? auth = await gUser.authentication;
    if (auth == null) {
      throw Exception("expected google signin auth.");
    }
    if (auth.idToken == null) {
      throw Exception("expected google id_token.");
    }

    final fireUser = await _getFirebaseUser(context: context, gAuth: auth);
    if (fireUser == null) {
      throw Exception("expected firebase user.");
    }

    final User platformUser = await Requests.platformLogin(
        session, fireUser.uid, serverCode, auth.idToken!);

    inspect(platformUser);

    Navigator.pushReplacementNamed(context, HomeScreen.routeName,
        arguments: ScreenArguments(platformUser));
  }

  //_getFirebaseUser returns the current firebase auth user or signs into firebase auth
  //if an account doesn't already exist.
  static Future<fire_auth.User?> _getFirebaseUser(
      {required BuildContext context,
      required GoogleSignInAuthentication gAuth}) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    fire_auth.User? user = fire_auth.FirebaseAuth.instance.currentUser;
    if (user == null) {
      return _signIntoFirebase(context: context, gAuth: gAuth);
    }

    return user;
  }

  //_signIntoFirebase uses signed in google user to sign into firebaseAuth.
  static Future<fire_auth.User?> _signIntoFirebase(
      {required BuildContext context,
      required GoogleSignInAuthentication gAuth}) async {
    final fire_auth.AuthCredential credential =
        fire_auth.GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final fire_auth.FirebaseAuth auth = fire_auth.FirebaseAuth.instance;

    fire_auth.User? user;
    try {
      final fire_auth.UserCredential userCredential =
          await auth.signInWithCredential(credential);

      user = userCredential.user;
    } on fire_auth.FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          Snack.errorSnackBar(
            content: 'The account already exists with a different credential',
          ),
        );
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          Snack.errorSnackBar(
            content: 'Error occurred while accessing credentials. Try again.',
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Snack.errorSnackBar(
          content: 'Error occurred using Google Sign In. Try again.',
        ),
      );
    }

    return user;
  }

  //signOut signs us out of google and firebase accounts.
  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      await fire_auth.FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        Snack.errorSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}
