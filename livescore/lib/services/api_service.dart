import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livescore/models/fixture.dart';

class ApiService {
  final String baseUrl = "https://v3.football.api-sports.io/";
  final String apikey = "99f155ab0f98ae3f59b71b763d2b55e8";
  final String host = "v3.football.api-sports.io";

  Future<List<Fixture>> getAllMatchs() async {
    var headers = {'x-rapidapi-key': apikey, 'x-rapidapi-host': host};
    var request = http.Request('GET', Uri.parse('${baseUrl}fixtures?live=all'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      print(res);
      List<dynamic> body = jsonDecode(res);
      return body.map((item) => Fixture.fromJson(item)).toList();
    } else {
      throw (Exception(response.reasonPhrase));
    }
  }

  Future<Fixture> getMatch(String id) async {
    var headers = {'x-rapidapi-key': apikey, 'x-rapidapi-host': host};
    var request = http.Request('GET', Uri.parse('${baseUrl}fixtures?id=$id'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      print(res);
      return Fixture.fromJson(jsonDecode(res)["response"][0]);
    } else {
      print(response.reasonPhrase);
      throw (Exception(response.reasonPhrase));
    }
  }

  Future<List<Event>> getMatchEvents(String matchId) async {
    var headers = {'x-rapidapi-key': apikey, 'x-rapidapi-host': host};
    var request = http.Request(
        'GET', Uri.parse('${baseUrl}fixtures/events?fixture=$matchId'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      print(res);
      List<dynamic> body = jsonDecode(res);
      return body.map((item) => Event.fromJson(item)).toList();
    } else {
      throw (Exception(response.reasonPhrase));
    }
  }

  Future<String> getMatchLineups(String matchId) async {
    var headers = {'x-rapidapi-key': apikey, 'x-rapidapi-host': host};
    var request = http.Request(
        'GET', Uri.parse('${baseUrl}fixtures/lineups?fixture=$matchId'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return response.stream.bytesToString();
    } else {
      throw (Exception(response.reasonPhrase));
    }
  }
}
