import 'dart:math';
import 'package:flutter/material.dart';
import 'package:livescore/models/fixture.dart';
import 'package:livescore/providers/match_provider.dart';
import 'package:livescore/services/api_service.dart';
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
    // Carregar o match pelo ID assim que o widget for inicializado
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
                    minute:
                        (matchProvider.selectedMatch!.timestamp / 60).toInt(),
                    teams: matchProvider.selectedMatch!.teams!,
                  ),
                ),
                // Eventos/Planteis
                Expanded(child: GameInfo()),
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
  final int minute;
  final Goals goals;
  final Teams teams;
  const Placard(
      {super.key,
      required this.goals,
      required this.teams,
      required this.minute});
  @override
  Widget build(BuildContext context) {
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
          Image(
            image: NetworkImage(teams.home!.logo),
            fit: BoxFit.fitHeight,
          ),
          Column(
            children: [
              Text(
                "${goals.home}-${goals.away}",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "$minute'",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, fontSize: 10),
              )
            ],
          ),
          Image(
            image: NetworkImage(teams.away!.logo),
            fit: BoxFit.fitHeight,
          ),
        ],
      ),
    );
  }
}

class GameInfo extends StatefulWidget {
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
                  Resumo(),
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
  const Resumo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FractionallySizedBox(
                widthFactor: 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [Text("Cartão Amarelo")],
                    ),
                    Column(
                      children: [Text("57'")],
                    ),
                  ],
                ))
          ],
        ));
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
