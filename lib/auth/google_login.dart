import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = GoogleSignIn();

  void googleLogInUser(BuildContext context) async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googlSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      await _firebaseAuth
          .signInWithCredential(credential)
          .whenComplete(() async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("_id", googleSignInAccount.id.substring(0, 9));
      });
    } catch (e) {
      print(e);
    }
  }

  void googleLogOutUser(BuildContext context) {
    _googlSignIn.signOut();
    _firebaseAuth.signOut();
  }
}
