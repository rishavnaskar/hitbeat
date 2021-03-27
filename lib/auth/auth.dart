import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hitbeat/screens/login/login.dart';
import 'package:hitbeat/screens/navbar/navbar.dart';

class AuthService {
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData)
          return NavBarScreen();
        else
          return LoginScreen();
      },
    );
  }
}
