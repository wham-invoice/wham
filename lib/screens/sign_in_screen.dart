import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:loggy/loggy.dart';
import 'package:wham/utils/authentication.dart';
import 'package:wham/widgets/google_signin_button.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  GoogleSignInAccount? _currentGoogleUser;

//Called when this object is inserted into the tree.
//marks the instance as overriding superclass member.
  @override
  void initState() {
    // super calls base class initState
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        setState(() {
          _currentGoogleUser = account;
        });
      }
    });
  }

  //initialize starts the firebase and google sign in flow. We create the firebase app.
  //Then we see if a google user is signed in. If so we attempt to get signed in firebase user.
  //Last we call the onSignIn func.
  Future<FirebaseApp> initialize({
    required BuildContext context,
    required Loggy<UiLoggy> logger,
    required GoogleSignIn gSignIn,
  }) async {
    FirebaseApp fApp = await Authentication.initialize(
        context: context, logger: logger, gSignIn: gSignIn);

    await _googleSignIn.signInSilently();

    if (_currentGoogleUser != null) {
      AuthClient? googleClient = await _googleSignIn.authenticatedClient();
      GoogleSignInAuthentication? auth =
          await _currentGoogleUser!.authentication;

      fire_auth.User? _firebaseUser = await Authentication.signIntoFirebase(
          context: context, googleSignInAuthentication: auth);

      if (_firebaseUser != null && googleClient != null) {
        Authentication.onSignIn(
            context: context,
            logger: logger,
            firebaseUser: _firebaseUser,
            googleClient: googleClient);
      } else {
        logger.error("unexpected null firebaseUser || googleClient.");
      }
    }

    return fApp;
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              FutureBuilder(
                future: initialize(
                    context: context, logger: loggy, gSignIn: _googleSignIn),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return GoogleSignInButton(_googleSignIn);
                  }
                  return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.orange,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
