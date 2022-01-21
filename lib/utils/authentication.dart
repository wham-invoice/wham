import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:loggy/loggy.dart';
import 'package:wham/firebase_options.dart';
import 'package:wham/schema/user.dart';
import 'package:wham/screens/home_screen.dart';
import 'package:wham/screens/utils.dart';

class Authentication with UiLoggy {
  static onSignIn(
      {required BuildContext context,
      required Loggy<UiLoggy> logger,
      required fire_auth.User firebaseUser,
      required GoogleSignIn gSignIn}) async {
    DocumentSnapshot snap;
    try {
      snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!snap.exists) {
        logger.info("saving new user: $firebaseUser.uid");
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set({
          'displayName': firebaseUser.displayName,
          'uid': firebaseUser.uid
        });

        snap = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
      } else {
        logger.debug("user exists: $firebaseUser.uid");
      }
    } catch (e) {
      print("error: " + e.toString());
      return false;
    }

    AuthClient? googleClient = await gSignIn.authenticatedClient();

    User user;
    if (googleClient != null) {
      user = User(snap.id, snap.get('displayName'), googleClient);
      Navigator.pushReplacementNamed(context, HomeScreen.routeName,
          arguments: ScreenArguments(user));
    }
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
    required Loggy<UiLoggy> logger,
    required GoogleSignIn gSignIn,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    fire_auth.User? fUser = fire_auth.FirebaseAuth.instance.currentUser;

    if (fUser != null) {
      onSignIn(
          context: context,
          logger: logger,
          firebaseUser: fUser,
          gSignIn: gSignIn);
    }

    return firebaseApp;
  }

  static Future<fire_auth.User?> signInWithGoogle(
      {required BuildContext context, required GoogleSignIn gSignIn}) async {
    fire_auth.FirebaseAuth auth = fire_auth.FirebaseAuth.instance;
    fire_auth.User? user;

// if running via web. else...
    if (kIsWeb) {
      // TODO gmail API not enabled/set for web.
      fire_auth.GoogleAuthProvider authProvider =
          fire_auth.GoogleAuthProvider();

      try {
        final fire_auth.UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignInAccount? googleSignInAccount = await gSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final fire_auth.AuthCredential credential =
            fire_auth.GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final fire_auth.UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on fire_auth.FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
      }
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await fire_auth.FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}
