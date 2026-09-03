import 'package:livescore/models/fixture.dart';

class Lineup {
  final int teamId;
  final String formation;
  final List<Player> players;
  final List<Player> substitutes;
  final Coach? coach;

  Lineup(
      {required this.teamId,
      required this.formation,
      required this.players,
      required this.substitutes,
      required this.coach});

  factory Lineup.fromJson(Map<String, dynamic> json) {
    return Lineup(
        teamId: json['team']['id'],
        formation: json['formation'],
        players: (json['startXI'] as List<dynamic>?)
                ?.map((e) => Player.fromJson(e['player']))
                .toList() ??
            [],
        substitutes: (json['substitutes'] as List<dynamic>?)
                ?.map((e) => Player.fromJson(e['player']))
                .toList() ??
            [],
        coach: json['coach'] != null ? Coach.fromJson(json['coach']) : null);
  }
}

class Coach {
  final int id;
  final String name;
  final String photo;

  Coach({required this.id, required this.name, required this.photo});

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: json['id'] ?? -1,
      name: json['name'] ?? "null",
      photo: json['photo'] ?? "null",
    );
  }
}

class Colors {
  final String primary;
  final String number;
  final String border;

  Colors({required this.primary, required this.number, required this.border});

  factory Colors.fromJson(Map<String, dynamic> json) {
    return Colors(
      primary: json['primary'] ?? "null",
      number: json['number'] ?? "null",
      border: json['border'] ?? "null",
    );
  }
}
