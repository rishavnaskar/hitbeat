import 'dart:async';
import 'dart:io' as io;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:hitbeat/api/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordingScreen extends StatefulWidget {
  RecordingScreen(
      {@required this.title, @required this.url, @required this.tag});
  final String title;
  final String url;
  final String tag;
  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  FlutterAudioRecorder _recorder;
  Recording _recording;
  Timer _t;
  Widget _buttonIcon = Icon(Icons.mic);
  bool _isLiked = false;
  bool _isPlaying = false;
  AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          colors: [
            Color(0XFFF7B6D6),
            Colors.white,
          ],
        )),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Row(
                children: [
                  Text(widget.title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Rajdhani-Regular")),
                  Spacer(),
                  IconButton(
                    icon: _isLiked
                        ? Icon(Icons.favorite_outlined)
                        : Icon(Icons.favorite_border),
                    color: _isLiked ? Colors.pink : Colors.black,
                    iconSize: 30,
                    enableFeedback: true,
                    onPressed: () {
                      setState(() => _isLiked = !_isLiked);
                    },
                  )
                ],
              ),
              SizedBox(height: 20),
              Hero(
                tag: widget.tag,
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.url,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: _recording?.status == RecordingStatus.Stopped
                    ? (_isPlaying ? _stopPlay : _play)
                    : null,
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
                  elevation: MaterialStateProperty.all(10),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                ),
                child: Text(
                  _isPlaying ? "Playing..." : "Listen",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat"),
                ),
              ),
              SizedBox(height: 50),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Start Beatboxing",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 24,
                      color: Color(0XFF8E54E9),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Rajdhani-Regular"),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                        child: CircleAvatar(
                            child: IconButton(
                              icon: _buttonIcon,
                              onPressed: () => _opt(),
                            ),
                            backgroundColor: Colors.white,
                            radius: 23),
                        backgroundColor: Colors.black,
                        radius: 24),
                    SizedBox(width: 30),
                    Text(
                      '${_recording?.duration ?? "-"}',
                      style: TextStyle(fontSize: 20, fontFamily: "Montserrat"),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              CompareScreen(recording: _recording, beatName: widget.title),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _prepare();
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _opt() async {
    switch (_recording.status) {
      case RecordingStatus.Initialized:
        {
          await _startRecording();
          break;
        }
      case RecordingStatus.Recording:
        {
          await _stopRecording();
          break;
        }
      case RecordingStatus.Stopped:
        {
          await _prepare();
          break;
        }

      default:
        break;
    }

    setState(() {
      _buttonIcon = _playerIcon(_recording.status);
    });
  }

  Future _init() async {
    String customPath = '/flutter_audio_recorder_';
    io.Directory appDocDirectory;
    if (io.Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }

    customPath = appDocDirectory.path +
        customPath +
        DateTime.now().millisecondsSinceEpoch.toString();

    _recorder = FlutterAudioRecorder(customPath,
        audioFormat: AudioFormat.WAV, sampleRate: 22050);
    await _recorder.initialized;
  }

  Future _prepare() async {
    var hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      await _init();
      var result = await _recorder.current();
      setState(() {
        _recording = result;
        _buttonIcon = _playerIcon(_recording.status);
      });
    } else {
      setState(() {});
    }
  }

  Future _startRecording() async {
    await _recorder.start();
    var current = await _recorder.current();
    setState(() {
      _recording = current;
    });

    _t = Timer.periodic(Duration(milliseconds: 10), (Timer t) async {
      var current = await _recorder.current();
      setState(() {
        _recording = current;
        _t = t;
      });
    });
  }

  Future _stopRecording() async {
    var result = await _recorder.stop();
    _t.cancel();

    setState(() {
      _recording = result;
    });
  }

  void _play() {
    player.play(_recording.path, isLocal: true, volume: 100);
    setState(() => _isPlaying = true);

    // if (player.state == AudioPlayerState.COMPLETED) {
    //   setState(() {
    //     _isPlaying = false;
    //   });
    // }
  }

  void _stopPlay() {
    player.pause();

    setState(() => _isPlaying = false);
  }

  Widget _playerIcon(RecordingStatus status) {
    switch (status) {
      case RecordingStatus.Initialized:
        {
          return Icon(Icons.mic, color: Colors.black);
        }
      case RecordingStatus.Recording:
        {
          return Icon(Icons.stop, color: Colors.black);
        }
      case RecordingStatus.Stopped:
        {
          return Icon(Icons.replay, color: Colors.black);
        }
      default:
        return Icon(Icons.do_not_disturb_on, color: Colors.black);
    }
  }
}

class CompareScreen extends StatelessWidget {
  const CompareScreen({Key key, this.recording, this.beatName})
      : super(key: key);
  final Recording recording;
  final String beatName;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (recording.duration.toString() == "0:00:00.000000")
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Recording is invalid",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            backgroundColor: Color(0XFFF7B6D6),
          ));
        else
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            backgroundColor: Colors.grey[100],
            builder: (BuildContext bc) {
              return FutureBuilder(
                future: uploadUserAudio(),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    return Center(
                        child: Icon(Icons.error, color: Colors.black));
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.pink)));
                  if (snapshot.hasData) {
                    print("SNAPSHOT - ${snapshot.data}");
                  }
                  return Padding(
                    padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(child: SizedBox(height: 30)),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Keep improving, We are proud of you!",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(child: SizedBox(height: 40)),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Nice, You scored:",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Flexible(child: SizedBox(height: 20)),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("${snapshot.data["score"].toInt()}%",
                              style: TextStyle(
                                  fontFamily: "Montserrat", fontSize: 70)),
                        ),
                        Flexible(child: SizedBox(height: 20)),
                        Center(
                          child: FAProgressBar(
                            size: 40,
                            currentValue: snapshot.data["score"].toInt(),
                            displayText: "%",
                            changeColorValue: 100,
                            changeProgressColor: Colors.green,
                            borderRadius: BorderRadius.circular(30),
                            animatedDuration: Duration(seconds: 2),
                            backgroundColor: Colors.black,
                            progressColor: Color(0XFFF166AC),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              );
            },
          );
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
        elevation: MaterialStateProperty.all(10),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      ),
      child: Text(
        "Compare",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: "Montserrat"),
      ),
    );
  }

  Future uploadUserAudio() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String userId = pref.getString("_id");
    return await ApiService().uploadUserAudio(userId, beatName, recording.path);
  }
}
