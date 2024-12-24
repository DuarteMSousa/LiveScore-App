
import 'package:go_router/go_router.dart';
import 'package:livescore/screens/livegame_screen.dart';
import 'package:livescore/screens/matchlist_screen.dart';

/// Este é o arquivo de configuração do GoRouter.
///
/// Ele contém a configuração principal das rotas do aplicativo.
/// Utiliza o pacote [GoRouter] para definir as rotas e navegação entre elas.
final GoRouter router = GoRouter(
  /// Caminho inicial que será carregado ao abrir o aplicativo.
  /// Neste caso, é a página inicial do aplicativo.
  initialLocation: '/todayMatches',

  /// Define as rotas disponíveis no aplicativo.
  routes: [
    GoRoute(
      /// Rota para a página inicial.
      path: '/todayMatches',
      builder: (context, state) => const MatchlistScreen(),
    ),
    GoRoute(
      /// Rota para a página de login.
      path: '/livematch/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return LivegameScreen(id: id!);
      },
    ),
  ],
);
