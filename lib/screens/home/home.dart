import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitbeat/api/api.dart';
import 'package:hitbeat/screens/home/recording.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Image.asset(
              "assets/Motivation.png",
              fit: BoxFit.cover,
            ),
            SizedBox(height: 25),
            TextField(
              decoration: InputDecoration(
                enabled: false,
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                hintText: "What do you want to practice?",
                hintStyle:
                    TextStyle(color: Colors.grey, fontFamily: "Montserrat"),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(30)),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            SizedBox(height: 40),
            Text("Recently practised",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RecentlyPlayedWidget(url: "assets/Recent5.png"),
                RecentlyPlayedWidget(url: "assets/Recent4.png"),
                RecentlyPlayedWidget(url: "assets/Recent3.png"),
              ],
            ),
            SizedBox(height: 20),
            Text("More",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            FutureBuilder(
              future: _getBeats(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Center(child: Icon(Icons.error, color: Colors.black));
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.purple[800])));
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  physics: BouncingScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      Divider(thickness: 0, color: Colors.transparent),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (context, animation, ani) =>
                                  RecordingScreen(
                                    title: snapshot.data[index]['title'],
                                    url: snapshot.data[index]['beat_image'],
                                    tag: "hero$index",
                                  ))),
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0XFFFAE4EF),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0XFFFAE4EF),
                                  blurRadius: 2,
                                  spreadRadius: 2)
                            ]),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Hero(
                              tag: "hero$index",
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    snapshot.data[index]['beat_image'],
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.black),
                                          value: progress.expectedTotalBytes !=
                                                  null
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
                            SizedBox(width: 30),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(snapshot.data[index]['title'],
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Rajdhani-Regular",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25)),
                                  ),
                                  SizedBox(height: 20),
                                  Image.asset(
                                    "assets/Group8.png",
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future _getBeats() async {
    return await _apiService.getBeats();
  }
}

class RecentlyPlayedWidget extends StatelessWidget {
  RecentlyPlayedWidget({@required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        child: Image.asset(url),
      ),
    );
  }
}
