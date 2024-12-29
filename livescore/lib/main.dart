import 'package:flutter/material.dart';
import 'package:livescore/providers/search_provider.dart';
import 'package:livescore/providers/shared_preferences_provider.dart';
import 'package:livescore/router.dart';
import 'package:provider/provider.dart';
import 'package:livescore/providers/match_provider.dart';
import 'util.dart';
import 'theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MatchProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => SharedPreferencesProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Unbounded", "Unbounded");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: theme.dark(),
    );
  }
}
