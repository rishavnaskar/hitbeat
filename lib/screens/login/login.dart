import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hitbeat/auth/google_login.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  TextStyle _textStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: "Montserrat");
  bool _isLoading = false;
  VideoPlayerController _videoController;
  AnimationController animationController;
  Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) => SizedBox.expand(
                      child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: constraints.maxWidth *
                          _videoController.value.aspectRatio,
                      height: constraints.maxHeight,
                      child: VideoPlayer(_videoController),
                    ),
                  )),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 30, 0),
                    child: Column(
                      children: [
                        Transform.rotate(
                          angle: animation.value,
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/logo.png"),
                            radius: MediaQuery.of(context).size.width / 8,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("HIT BEAT",
                            style: _textStyle.copyWith(
                                fontFamily: "Della_Respira",
                                fontSize: 24,
                                color: Colors.white))
                      ],
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: SizedBox(
                        height: 40,
                        child: SignInButton(
                          Buttons.Google,
                          onPressed: () =>
                              GoogleAuth().googleLogInUser(context),
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.only(left: 40),
                        ),
                      ),
                    )),
              ],
            )),
      ),
    );
  }

  @override
  void initState() {
    _videoController = VideoPlayerController.asset("assets/login_video.mp4");
    _videoController.initialize().then((value) {
      _videoController.play();
      _videoController.setLooping(true);
      _videoController.setVolume(0.0);
      setState(() {});
    });

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    final curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.bounceIn,
      reverseCurve: Curves.easeOut,
    );

    animation =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              animationController.forward();
            }
          });
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    animationController.dispose();
    super.dispose();
  }
}
