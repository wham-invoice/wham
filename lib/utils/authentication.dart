import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wham/utils/session.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loggy/loggy.dart';
import 'package:wham/firebase_options.dart';
import 'package:wham/schema/user.dart';
import 'package:wham/utils/snackbar.dart';

class Authentication with UiLoggy {
  static Future<User> getUser(
      {required BuildContext context,
      required Loggy<UiLoggy> logger,
      required GoogleSignInAuthentication auth,
      required AuthClient googleClient,
      required Session session}) async {
    final fire_auth.User? firebaseUser =
        await Authentication._getFirebaseUser(context: context, gAuth: auth);
    if (firebaseUser == null) throw Exception("errored signing into firebase.");

    FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set(
        {'displayName': firebaseUser.displayName, 'uid': firebaseUser.uid});

    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    return User(snap.id, snap.get('displayName'), googleClient, session);
  }

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

//signIntoFirebaseWithGoogle uses signed in google user to sign into firebaseAuth.
//We return the signed in firebase account.
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
      ScaffoldMessenger.of(context).showSnackBar(
        Snack.errorSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}
