import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livescore/models/fixture.dart';
import 'package:livescore/providers/match_provider.dart';
import 'package:livescore/providers/shared_preferences_provider.dart';
import 'package:livescore/widgets/AutoScrollText.dart';
import 'package:livescore/widgets/bottombar.dart';
import 'package:livescore/widgets/topbar.dart';
import 'package:provider/provider.dart';

class MatchlistScreen extends StatefulWidget {
  const MatchlistScreen({Key? key}) : super(key: key);

  @override
  _MatchlistScreenState createState() => _MatchlistScreenState();
}

class _MatchlistScreenState extends State<MatchlistScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    loadMatches();
  }

  Future<void> loadMatches() async {
    await context.read<MatchProvider>().loadAllTodayMatches();
    await context.read<SharedPreferencesProvider>().loadFavTeams();
    await context.read<MatchProvider>().loadAllFavTeamsMatches(
        context.read<SharedPreferencesProvider>().favTeams.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Topbar(),
      body: Consumer2<MatchProvider, SharedPreferencesProvider>(
          builder: (context, matchProvider, sharedPreferencesProvider, child) {
        if (matchProvider.isLoading.value ||
            sharedPreferencesProvider.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (matchProvider.errorMessage.value.isNotEmpty ||
            sharedPreferencesProvider.errorMessage.value.isNotEmpty) {
          return Center(child: Text(matchProvider.errorMessage.value));
        }
        return Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
            child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(text: "Favoritos"),
                        Tab(text: "Todos"),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: TabBarView(
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              if (matchProvider.favSelectedMatchesHash!.isEmpty)
                                Center(
                                  child: Text(
                                    "Sem clubes favoritos",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiary),
                                  ),
                                ),
                              for (var leagueId
                                  in matchProvider.favSelectedMatchesHash!.keys)
                                Column(
                                  children: [
                                    leagueHeader(
                                        league: matchProvider
                                            .favSelectedMatchesHash![leagueId]![
                                                0]
                                            .league!),
                                    for (var match in matchProvider
                                        .favSelectedMatchesHash![leagueId]!)
                                      MatchCard(match: match)
                                  ],
                                ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              for (var leagueId
                                  in matchProvider.allSelectedMatchesHash!.keys)
                                Column(
                                  children: [
                                    leagueHeader(
                                        league: matchProvider
                                            .allSelectedMatchesHash![leagueId]![
                                                0]
                                            .league!),
                                    for (var match in matchProvider
                                        .allSelectedMatchesHash![leagueId]!)
                                      MatchCard(match: match)
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ))
                  ],
                )));
      }),
      bottomNavigationBar: BottomBar(),
    );
  }
}

class MatchCard extends StatelessWidget {
  final Fixture match;

  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          context.push('/livematch/${match.id}');
        },
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      match.teams!.home!.name,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onTertiary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(
                          "${match.goals!.home} - ${match.goals!.away}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          processMatchShort(match.status!.short,
                              match.status!.elapsed, match.date),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 10),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      match.teams!.away!.name,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onTertiary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Theme.of(context).colorScheme.surface,
              )
            ],
          ),
        ));
  }
}

String processMatchShort(String short, int elapsed, DateTime date) {
  if (short == "FT" || short == "HT" || short == "TBD") {
    return short;
  } else if (short == "1H" || short == "2H") {
    return "$elapsed'";
  } else if (short == "NS") {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
  return short;
}

class leagueHeader extends StatelessWidget {
  final League league;

  const leagueHeader({super.key, required this.league});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AutoScrollText(
                    text: league.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Image(
                  image: NetworkImage(league.logo),
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    );
                  },
                ),
              ],
            ),
            Divider(
              color: Theme.of(context).colorScheme.onTertiary,
              height: 3,
            )
          ],
        ));
  }
}
