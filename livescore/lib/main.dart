import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livescore/providers/match_provider.dart';
import 'package:livescore/screens/livegame_screen.dart';
import 'util.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    TextTheme textTheme = createTextTheme(context, "Unbounded", "Unbounded");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MatchProvider()), // Provider inicializado aqui
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: theme.dark(),
        home: const LivegameScreen(id: '1214989'),
      ),
    );
  }
}
