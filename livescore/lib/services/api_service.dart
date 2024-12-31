import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livescore/models/fixture.dart';
import 'package:livescore/models/lineup.dart';

class ApiService {
  final String baseUrl = "https://v3.football.api-sports.io/";
  final String apikey = "99f155ab0f98ae3f59b71b763d2b55e8";
  final String host = "v3.football.api-sports.io";

  Future<List<Fixture>> getAllMatchesToday() async {
    var headers = {'x-rapidapi-key': apikey, 'x-rapidapi-host': host};
    var request = http.Request(
        'GET',
        Uri.parse(
            '${baseUrl}fixtures?date=${DateTime.now().toIso8601String().split("T")[0]}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      print(res);
      List<dynamic> body = jsonDecode(res)["response"];
      return body.map((item) => Fixture.fromJson(item)).toList();
    } else {
      throw (Exception(response.reasonPhrase));
    }
  }

  Future<Fixture> getTeamMatchesToday(int team) async {
    var headers = {'x-rapidapi-key': apikey, 'x-rapidapi-host': host};
    var currentDate = DateTime.now();
    var request = http.Request(
        'GET',
        Uri.parse(
            '${baseUrl}fixtures?date=${currentDate.toIso8601String().split("T")[0]}&team=$team&season=${currentDate.year}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      print(res);
      List<dynamic> body = jsonDecode(res)["response"];
      return Fixture.fromJson(body[0]);
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
      return Fixture.fromJson(jsonDecode(res)["response"][0]);
    } else {
      print(response.reasonPhrase);
      throw (Exception(response.reasonPhrase));
    }
  }

  // Future<List<Event>> getMatchEvents(String matchId) async {
  //   var headers = {'x-rapidapi-key': apikey, 'x-rapidapi-host': host};
  //   var request = http.Request(
  //       'GET', Uri.parse('${baseUrl}fixtures/events?fixture=$matchId'));
  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     var res = await response.stream.bytesToString();
  //     print(res);
  //     List<dynamic> body = jsonDecode(res);
  //     return body.map((item) => Event.fromJson(item)).toList();
  //   } else {
  //     throw (Exception(response.reasonPhrase));
  //   }
  // }

  Future<List<Lineup>> getMatchLineups(String matchId) async {
    var headers = {'x-rapidapi-key': apikey, 'x-rapidapi-host': host};
    var request = http.Request(
        'GET', Uri.parse('${baseUrl}fixtures/lineups?fixture=$matchId'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      List<dynamic> body = jsonDecode(res)['response'];
      return body.map((item) => Lineup.fromJson(item)).toList();
    } else {
      throw (Exception(response.reasonPhrase));
    }
  }

  Future<List<Team>> searchTeams(String search) async {
    var headers = {'x-rapidapi-key': apikey, 'x-rapidapi-host': host};
    var request =
        http.Request('GET', Uri.parse('${baseUrl}teams?search=$search'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      print(res);
      List<dynamic> body = jsonDecode(res)["response"];
      return body.map((item) => Team.fromJson(item["team"])).toList();
    } else {
      throw (Exception(response.reasonPhrase));
    }
  }
}
