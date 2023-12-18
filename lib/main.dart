import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_project_fb_2/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  /**
   * 1. Ensure that Firebase is initialized before calling any Firebase methods.
   * 2. Initialize Firebase with a default Firebase project.
   * 3. Retrieve your Firebase project's default Google service account credentials from the Firebase console.
   */

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerPassword = TextEditingController();

  // UI code for your app)
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              // trigger the authentication flow on button press
              onPressed: () {
                signInWithGoogle(context);
              },
              child: Text("Sign In with Google ")),
          TextField(
            controller: textEditingControllerEmail,
          ),
          TextField(
            controller: textEditingControllerPassword,
          ),
          ElevatedButton(
              onPressed: () {
                tryEmailPWSignIn(textEditingControllerEmail.text,
                    textEditingControllerPassword.text);
              },
              child: const Text("Sign in with Email and Password"))
        ],
      )),
    );
  }
}

/*
 * 1. Create an instance of the FirebaseAuth class.
 * 2. Call the createUserWithEmailAndPassword method to create a new user account with the user's email address and password.
 * 3. If the new account was created, the user is signed in automatically.
 * 4. If the user signs in to a new account successfully, the method returns a UserCredential object.
 * 5. If sign in fails, the method throws a FirebaseAuthException.
 * 6. If the email address is already in use by a different account, the method throws a FirebaseAuthException.
 */
Future<void> tryEmailPWSignIn(String emailAddress, String password) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    print(e);
  } catch (e) {
    print(e);
  }
}

/**
 * 1. Create a Google Sign-In configuration object with the scopes you need.
 * 2. Present Google Sign-In to the user.
 * 3. Get the user's Google ID token and Google access token from the GoogleSignInAuthentication object.
 * 4. Create a new credential object using the tokens from GoogleSignInAuthentication.
 * 5. Once signed in, return the UserCredential object.
 */
Future<UserCredential> signInWithGoogle(BuildContext context) async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
