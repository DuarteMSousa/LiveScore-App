import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livescore/models/fixture.dart';
import 'package:livescore/providers/match_provider.dart';
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
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    context.read<MatchProvider>().loadAllTodayMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Topbar(),
      body: Consumer<MatchProvider>(builder: (context, matchProvider, child) {
        if (matchProvider.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (matchProvider.errorMessage.value.isNotEmpty) {
          return Center(child: Text(matchProvider.errorMessage.value));
        }

        return Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 20),
            child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    TabBar(
                      padding: EdgeInsets.only(top: 15),
                      controller: _tabController,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(text: "Favoritos"),
                        Tab(text: "Todos"),
                      ],
                    ),
                    Expanded(
                        child: TabBarView(
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              for (var leagueId
                                  in matchProvider.selectedmatchHash!.keys)
                                Column(
                                  children: [
                                    leagueHeader(
                                        league: matchProvider
                                            .selectedmatchHash![leagueId]![0]
                                            .league!),
                                    for (var match in matchProvider
                                        .selectedmatchHash![leagueId]!)
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
                          match.status!.short == "FT"
                              ? "FT"
                              : match.status!.short == "HT"
                                  ? "HT"
                                  : "${match.status!.elapsed}'${match.status!.extra > 0 ? "+${match.status!.extra}'" : ''}",
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
                Text(
                  league.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image(
                  image: NetworkImage(league.logo),
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
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
