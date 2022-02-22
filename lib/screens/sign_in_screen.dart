import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:wham/schema/user.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:loggy/loggy.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wham/utils/authentication.dart';
import 'package:wham/utils/session.dart';
import 'package:wham/utils/snackbar.dart';
import 'package:wham/screens/utils.dart';
import 'package:wham/widgets/google_signin_button.dart';
import 'package:wham/screens/home_screen.dart';

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
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        setState(() {
          _currentGoogleUser = account;
        });
      }
    });
  }

  Future<http.Response> backendAuth(Session s, String code) => s.post(
      'http://localhost:8080/auth', jsonEncode(<String, String>{'code': code}));

  //Attempts to sign in a previously authenticated user without interaction.
  //If the currently signed in user errors whilst authenticating w BE we sign out.
  Future<void> _attemptSilentSignIn({
    required BuildContext context,
    required Loggy<UiLoggy> logger,
    required GoogleSignIn gSignIn,
  }) async {
    final Session session = Session();

    await _googleSignIn.signInSilently();

    if (_currentGoogleUser == null) return;

    try {
      loggy.info("user ${_currentGoogleUser}");
      String? serverCode = _currentGoogleUser!.serverAuthCode;
      if (serverCode == null || serverCode == "") {
        throw Exception("expected server code");
      }
      // Authenticate with wham backend.
      final http.Response resp = await backendAuth(session, serverCode);
      if (resp.statusCode != 200) {
        throw Exception(
            "authenticate with platform: ${resp.statusCode} ${resp.reasonPhrase}");
      }
      loggy.info(resp.toString());

      final AuthClient? googleClient =
          await _googleSignIn.authenticatedClient();
      if (googleClient == null) {
        throw Exception("expected google client.");
      }

      final GoogleSignInAuthentication? auth =
          await _currentGoogleUser!.authentication;
      if (auth == null) {
        throw Exception("expected google signin auth.");
      }

      final user = await Authentication.getUser(
          context: context,
          logger: logger,
          auth: auth,
          googleClient: googleClient,
          session: session);

      Navigator.pushReplacementNamed(context, HomeScreen.routeName,
          arguments: ScreenArguments(user));
    } on Exception catch (e, s) {
      loggy.error(e.toString());
      loggy.error(s.toString());
      //     await Authentication.signOut(context: context);
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              FutureBuilder(
                future: _attemptSilentSignIn(
                    context: context, logger: loggy, gSignIn: _googleSignIn),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    loggy.error(snapshot.error);
                    Snack.errorSnackBar(
                        content: "Error signing in ${snapshot.error}");
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    return GoogleSignInButton(_googleSignIn);
                  }

                  return const Text("Loading");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
