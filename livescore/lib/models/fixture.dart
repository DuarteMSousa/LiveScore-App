class Fixture {
  final int id;
  final String timezone;
  final DateTime date;
  final int timestamp;
  final Periods? periods;
  final Venue? venue;
  final League? league;
  final Teams? teams;
  final Goals? goals;
  final List<Event>? events;

  Fixture(
      {required this.id,
      required this.timezone,
      required this.date,
      required this.timestamp,
      required this.periods,
      required this.venue,
      required this.league,
      required this.teams,
      required this.goals,
      required this.events});

factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(
    id:json['fixture']['id'],
    timezone:json['fixture']['timezone'],
    date:json['fixture']['date'],
    timestamp:json['fixture']['timestamp'],
    periods:json['fixture']['periods'] != null ? Periods.fromJson(json['periods']) : null,
    venue:json['fixture']['venue'] != null ? Venue.fromJson(json['venue']) : null,
    league:json['league'] != null ? League.fromJson(json['league']) : null,
    teams:json['teams'] != null ? Teams.fromJson(json['teams']) : null,
    goals:json['goals'] != null ? Goals.fromJson(json['goals']) : null,
    events: (json['events'] as List<dynamic>?)
              ?.map((e) => Event.fromJson(e))
              .toList() ??
          [],
    );
  }      
}

class Event {
  final Time? time;
  final Team? team;
  final Player? player;
  final Player? assist;
  final String type;
  final String detail;

  Event(
      {required this.time,
      required this.team,
      required this.player,
      required this.assist,
      required this.type,
      required this.detail});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      time: json['time'] != null ? Time.fromJson(json['time']) : null,
      team: json['team'] != null ? Team.fromJson(json['team']) : null,
      player: json['player'] != null ? Player.fromJson(json['player']) : null,
      assist: json['assist'] != null ? Player.fromJson(json['assist']) : null,
      type: json['type'],
      detail: json['detail'],
    );
  }
}

class Player {
  final int id;
  final String name;

  Player({required this.id, required this.name});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Time {
  final int elapsed;
  final int extra;

  Time({required this.elapsed, required this.extra});

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      elapsed: json['elapsed'],
      extra: json['extra'],
    );
  }
}

class Goals {
  final int home;
  final int away;

  Goals({required this.home, required this.away});

  factory Goals.fromJson(Map<String, dynamic> json) {
    return Goals(
      home: json['home'],
      away: json['away'],
    );
  }
}

class League {
  final int id;
  final String name;
  final String country;
  final String logo;
  final String flag;
  final int season;
  final String round;

  League(
      {required this.id,
      required this.name,
      required this.country,
      required this.logo,
      required this.flag,
      required this.season,
      required this.round});

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      logo: json['logo'],
      flag: json['flag'],
      season: json['season'],
      round: json['round'],
    );
  }
}

class Venue {
  final int id;
  final String name;
  final String city;

  Venue({required this.id, required this.name, required this.city});

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      name: json['name'],
      city: json['city'],
    );
  }
}

class Periods {
  final int first;
  final int second;

  Periods({required this.first, required this.second});

  factory Periods.fromJson(Map<String, dynamic> json) {
    return Periods(
      first: json['first'],
      second: json['second'],
    );
  }
}

class Teams {
  final Team? home;
  final Team? away;

  Teams({required this.home, required this.away});

  factory Teams.fromJson(Map<String, dynamic> json) {
    return Teams(
      home: json['home'] != null ? Team.fromJson(json['time']) : null,
      away: json['away'] != null ? Team.fromJson(json['team']) : null,
    );
  }
}

class Team {
  final int id;
  final String name;
  final String logo;

  Team({required this.id, required this.name, required this.logo});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
    );
  }
}
