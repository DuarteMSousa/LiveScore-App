import 'package:flutter/material.dart';
import 'package:livescore/models/fixture.dart';
import 'package:livescore/providers/match_provider.dart';
import 'package:livescore/screens/matchlist_screen.dart';
import 'package:livescore/widgets/topbar.dart';
import 'package:livescore/widgets/bottombar.dart';
import 'package:provider/provider.dart';

class LivegameScreen extends StatefulWidget {
  final String id;
  const LivegameScreen({super.key, required this.id});

  @override
  _LivegameScreenState createState() => _LivegameScreenState();
}

class _LivegameScreenState extends State<LivegameScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MatchProvider>().loadMatchById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Topbar(),
      body: Consumer<MatchProvider>(
        builder: (context, matchProvider, child) {
          if (matchProvider.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (matchProvider.errorMessage.value.isNotEmpty) {
            return Center(child: Text(matchProvider.errorMessage.value));
          }

          return Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
            child: Column(
              children: [
                // Placard
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  child: Placard(
                    goals: matchProvider.selectedMatch!.goals!,
                    status: matchProvider.selectedMatch!.status!,
                    teams: matchProvider.selectedMatch!.teams!,
                  ),
                ),
                // Eventos/Planteis
                Expanded(
                    child: GameInfo(
                  events: matchProvider.selectedMatch!.events!,
                  homeId: matchProvider.selectedMatch!.teams!.home!.id,
                )),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}

class Placard extends StatelessWidget {
  final Status status;
  final Goals goals;
  final Teams teams;
  const Placard({
    super.key,
    required this.goals,
    required this.teams,
    required this.status,
  });
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onTertiary.withOpacity(0.6),
            offset: Offset(0, -1),
            blurRadius: 5.3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                    height: screenHeight * 0.10,
                    image: NetworkImage(teams.home!.logo),
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(height: 15),
                  Text(teams.home!.name,
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onTertiary))
                ],
              )),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  "${goals.home} - ${goals.away}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  processMatchShort(
                      status.short, status.elapsed, DateTime.now()),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 10),
                )
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                    height: screenHeight * 0.1,
                    image: NetworkImage(teams.away!.logo),
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(height: 15),
                  Text(
                    teams.away!.name,
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onTertiary),
                  )
                ],
              ))
        ],
      ),
    );
  }
}

class GameInfo extends StatefulWidget {
  final List<Event> events;
  final int homeId;
  const GameInfo({super.key, required this.events, required this.homeId});
  @override
  _GameInfoState createState() => _GameInfoState();
}

class _GameInfoState extends State<GameInfo> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            TabBar(
              padding: EdgeInsets.only(top: 20),
              tabs: [
                Text(
                  "Resumo",
                ),
                Text("Planteis")
              ],
              dividerColor: Colors.transparent,
              controller: _tabController,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Resumo(events: widget.events, homeId: widget.homeId),
                  Planteis(),
                ],
              ),
            )
          ],
        ));
  }
}

class Planteis extends StatelessWidget {
  const Planteis({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://i.imgur.com/7mF6KDO.jpeg'),
              fit: BoxFit.fitHeight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10), child: Team()),
        ));
  }
}

class Resumo extends StatelessWidget {
  final List<Event> events;
  final int homeId;
  const Resumo({super.key, required this.events, required this.homeId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: events.map((event) {
            return FractionallySizedBox(
                widthFactor: 1,
                child: EventLine(event: event, home: event.team!.id == homeId));
          }).toList(),
        ),
      ),
    );
  }
}

class EventLine extends StatelessWidget {
  final Event event;
  final bool home;
  const EventLine({super.key, required this.event, required this.home});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: home ? EventInfo(event: event, home: home) : Text(""),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "${event.time!.elapsed}'",
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
                flex: 1,
                child: home ? Text("") : EventInfo(event: event, home: home)),
          ],
        ));
  }
}

class EventInfo extends StatelessWidget {
  final Event event;
  final bool home;
  const EventInfo({super.key, required this.event, required this.home});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: home ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (event.type == "Goal") ...[
          home ? Icon(Icons.sports_soccer) : SizedBox(),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment:
                    home ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  Text(
                    "Golo!",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onTertiary,
                        fontSize: 12),
                  ),
                  Text(event.player!.name,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 10))
                ],
              )),
          !home ? Icon(Icons.sports_soccer) : SizedBox(),
        ] else if (event.type == "Card") ...[
          home
              ? Transform.rotate(
                  angle: 90 * (3.141592653589793 / 180),
                  child: Icon(Icons.rectangle_rounded))
              : SizedBox(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment:
                  home ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Text(
                  event.detail,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiary,
                      fontSize: 12),
                ),
                Text(event.player!.name,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 10))
              ],
            ),
          ),
          !home
              ? Transform.rotate(
                  angle: 90 * (3.141592653589793 / 180),
                  child: Icon(Icons.rectangle_rounded))
              : SizedBox()
        ] else if (event.type == "subst") ...[
          home ? Icon(Icons.subdirectory_arrow_right) : SizedBox(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment:
                  home ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Text(
                  "Substituição",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiary,
                      fontSize: 12),
                ),
                Row(
                  children: [
                    Text(event.assist!.name,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 10)),
                    Icon(
                      Icons.arrow_forward,
                      size: 13,
                    ),
                    Text(event.player!.name,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 10))
                  ],
                )
              ],
            ),
          ),
          !home ? Icon(Icons.subdirectory_arrow_right) : SizedBox(),
        ]
      ],
    );
  }
}

class Player extends StatelessWidget {
  const Player({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            print("Circle Avatar tapped!");
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
        ),
        Text("Name")
      ],
    );
  }
}

class Team extends StatelessWidget {
  const Team({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(height: screenHeight * 0.03),
                      Player(),
                    ],
                  ),
                  Player(),
                  Column(
                    children: [SizedBox(height: screenHeight * 0.03), Player()],
                  ),
                ],
              )),
          SizedBox(height: screenHeight * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Player(), Player(), Player()],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Player(),
              Column(
                children: [SizedBox(height: screenHeight * 0.02), Player()],
              ),
              Column(
                children: [SizedBox(height: screenHeight * 0.02), Player()],
              ),
              Player()
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Player(),
        ],
      ),
    );
  }
}
