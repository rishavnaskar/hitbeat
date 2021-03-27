import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  Future addUser(String name, String email, String photoUrl, String id) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('https://hit-beat.herokuapp.com/userpost/'));
    request.body =
        '''{\r\n    "name": "$name",\r\n    "email": "$email",\r\n    "profile_pic": "$photoUrl",\r\n    "id": $id\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getBeats() async {
    var request = http.Request(
        'GET', Uri.parse('https://hit-beat.herokuapp.com/beatsget'));
    request.body = '''''';

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString()) as List;
    } else {
      print(response.reasonPhrase);
    }
  }

  Future uploadUserAudio(
      String userId, String beatName, String userAudioPath) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://hit-beat.herokuapp.com/useraudiopost/'));
    request.fields.addAll({'user': '$userId', 'beat_audio': '$beatName'});
    request.files.add(await http.MultipartFile.fromPath(
        'user_audio', '$userAudioPath'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
