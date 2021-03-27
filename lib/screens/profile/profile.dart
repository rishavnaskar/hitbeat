import 'package:flutter/material.dart';
import 'package:hitbeat/auth/google_login.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: IconButton(
          icon: Icon(Icons.exit_to_app),
          color: Colors.black,
          onPressed: () => GoogleAuth().googleLogOutUser(context),
        ),
      ),
    );
  }
}
