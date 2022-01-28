import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loggy/loggy.dart';
import 'package:wham/firebase_options.dart';
import 'package:wham/schema/user.dart';
import 'package:wham/screens/home_screen.dart';
import 'package:wham/screens/utils.dart';

class Authentication with UiLoggy {
  // onSignIn takes a FirebaseUser and a google AuthClient then get/sets
  // the user in our users firestore.
  // We initiate the user member then call pushReplacementNamed to direct
  // to the HomeScreen (passing in the new User).
  static onSignIn(
      {required BuildContext context,
      required Loggy<UiLoggy> logger,
      required fire_auth.User firebaseUser,
      required AuthClient googleClient}) async {
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

      User user = User(snap.id, snap.get('displayName'), googleClient);

      Navigator.pushReplacementNamed(context, HomeScreen.routeName,
          arguments: ScreenArguments(user));
    } catch (e) {
      logger.error(e.toString());
      return false;
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

  //initializeFirebase returns the FirebaseApp and calls onSignIn if a logged in FirebaseUser already
  //exists.
  static Future<FirebaseApp> initialize({
    required BuildContext context,
    required Loggy<UiLoggy> logger,
    required GoogleSignIn gSignIn,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    return firebaseApp;
  }

  static Future<fire_auth.User?> signIntoFirebase(
      {required BuildContext context,
      required GoogleSignInAuthentication googleSignInAuthentication}) async {
    fire_auth.FirebaseAuth auth = fire_auth.FirebaseAuth.instance;
    fire_auth.User? user = fire_auth.FirebaseAuth.instance.currentUser;

    if (user != null) {
      return user;
    }

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
              content: 'The account already exists with a different credential',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred while accessing credentials. Try again.',
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
